// merge_settings.go — Analyse ~/.claude/settings.json and produce a safe-merge result.
//
// Usage: merge_settings <settings_path> [ecc_clone_path]
//
// Output (JSON on stdout):
//
//	{"status": "new",        "merged": {...}, "details": []}
//	{"status": "ok",         "merged": {...}, "details": []}
//	{"status": "conflict",   "merged": {...}, "details": ["key: 'old' -> 'new'", ...]}
//	{"status": "parse_error","details": ["<error>"]}
package main

import (
	"encoding/json"
	"fmt"
	"os"
)

const (
	marketplaceName = "everything-claude-code"
	pluginKey       = "everything-claude-code@everything-claude-code"
)

type result struct {
	Status  string         `json:"status"`
	Merged  map[string]any `json:"merged,omitempty"`
	Details []string       `json:"details"`
}

func fatal(r result) {
	out, _ := json.Marshal(r)
	fmt.Println(string(out))
	os.Exit(0)
}

func main() {
	if len(os.Args) < 2 {
		fmt.Fprintln(os.Stderr, "Usage: merge_settings <settings_path> [ecc_clone_path]")
		os.Exit(1)
	}

	settingsPath := os.Args[1]
	clonePath := ""
	if len(os.Args) > 2 {
		clonePath = os.Args[2]
	}

	desired := buildDesired(clonePath)

	data, err := os.ReadFile(settingsPath)
	if os.IsNotExist(err) {
		fatal(result{Status: "new", Merged: desired, Details: []string{}})
	}
	if err != nil {
		fatal(result{Status: "parse_error", Details: []string{err.Error()}})
	}

	var existing map[string]any
	if err := json.Unmarshal(data, &existing); err != nil {
		fatal(result{Status: "parse_error", Details: []string{err.Error()}})
	}

	var conflicts []string

	// model
	if v, ok := existing["model"]; ok && v != desired["model"] {
		conflicts = append(conflicts, fmt.Sprintf("model: '%v' -> '%v'", v, desired["model"]))
	}

	// env keys
	desiredEnv := desired["env"].(map[string]any)
	if existingEnv, ok := existing["env"].(map[string]any); ok {
		for k, dv := range desiredEnv {
			if ev, ok := existingEnv[k]; ok && ev != dv {
				conflicts = append(conflicts, fmt.Sprintf("env.%s: '%v' -> '%v'", k, ev, dv))
			}
		}
	}

	// marketplace path
	if clonePath != "" {
		if existingMkt, ok := existing["extraKnownMarketplaces"].(map[string]any); ok {
			if mkt, ok := existingMkt[marketplaceName].(map[string]any); ok {
				if src, ok := mkt["source"].(map[string]any); ok {
					if oldPath, ok := src["path"].(string); ok && oldPath != clonePath {
						conflicts = append(conflicts,
							fmt.Sprintf("extraKnownMarketplaces.%s.source.path: '%s' -> '%s'",
								marketplaceName, oldPath, clonePath))
					}
				}
			}
		}

		if existingPlugins, ok := existing["enabledPlugins"].(map[string]any); ok {
			if enabled, ok := existingPlugins[pluginKey].(bool); ok && !enabled {
				conflicts = append(conflicts, fmt.Sprintf("enabledPlugins.%s: false -> true", pluginKey))
			}
		}
	}

	merged := merge(existing, desired, clonePath)

	status := "ok"
	if len(conflicts) > 0 {
		status = "conflict"
	}
	fatal(result{Status: status, Merged: merged, Details: conflicts})
}

func buildDesired(clonePath string) map[string]any {
	d := map[string]any{
		"model": "sonnet",
		"env": map[string]any{
			"MAX_THINKING_TOKENS":              "10000",
			"CLAUDE_AUTOCOMPACT_PCT_OVERRIDE":  "50",
			"CLAUDE_CODE_SUBAGENT_MODEL":       "haiku",
		},
	}
	if clonePath != "" {
		d["extraKnownMarketplaces"] = map[string]any{
			marketplaceName: map[string]any{
				"source": map[string]any{
					"source": "directory",
					"path":   clonePath,
				},
			},
		}
		d["enabledPlugins"] = map[string]any{
			pluginKey: true,
		}
	}
	return d
}

func merge(existing, desired map[string]any, clonePath string) map[string]any {
	merged := make(map[string]any, len(existing))
	for k, v := range existing {
		merged[k] = v
	}

	if _, ok := merged["model"]; !ok {
		merged["model"] = desired["model"]
	}

	desiredEnv := desired["env"].(map[string]any)
	mergedEnv := make(map[string]any)
	if existingEnv, ok := existing["env"].(map[string]any); ok {
		for k, v := range existingEnv {
			mergedEnv[k] = v
		}
	}
	for k, v := range desiredEnv {
		mergedEnv[k] = v
	}
	merged["env"] = mergedEnv

	if clonePath != "" {
		mergedMkt := make(map[string]any)
		if existingMkt, ok := existing["extraKnownMarketplaces"].(map[string]any); ok {
			for k, v := range existingMkt {
				mergedMkt[k] = v
			}
		}
		mergedMkt[marketplaceName] = desired["extraKnownMarketplaces"].(map[string]any)[marketplaceName]
		merged["extraKnownMarketplaces"] = mergedMkt

		mergedPlugins := make(map[string]any)
		if existingPlugins, ok := existing["enabledPlugins"].(map[string]any); ok {
			for k, v := range existingPlugins {
				mergedPlugins[k] = v
			}
		}
		mergedPlugins[pluginKey] = true
		merged["enabledPlugins"] = mergedPlugins
	}

	return merged
}
