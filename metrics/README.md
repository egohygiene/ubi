# 📈 UBI Build Metrics

This directory contains historical build metrics and observability data for the UBI container image.

## 📊 Files

- **build-metrics.jsonl**: Historical metrics in JSON Lines format (one entry per build)
- **metrics-{version}.json**: Detailed metrics report for a specific version
- **metrics-{version}.md**: Human-readable metrics report for a specific version
- **layers-{version}.json**: Layer breakdown for a specific version

## 📋 Metrics Collected

### Image Size Metrics
- **Compressed Size**: Total size of the image when compressed
- **Uncompressed Size**: Total size of all layers when extracted
- **Per-Architecture**: Separate metrics for amd64 and arm64

### Layer Metrics
- **Layer Count**: Total number of layers in the image
- **Layer Breakdown**: Size and command for each layer
- **Top Layers**: Identification of largest layers for optimization

### Build Metadata
- **Version**: Semantic version from VERSION file
- **Commit**: Git commit SHA
- **Timestamp**: Build date and time (UTC)
- **Workflow**: GitHub Actions workflow run ID

## 🔍 Usage

### View Historical Trends

```bash
# Count total builds
wc -l build-metrics.jsonl

# View latest metrics
tail -1 build-metrics.jsonl | jq '.'

# Compare sizes over time
jq -r '[.version, .timestamp, .amd64_size_mb] | @tsv' build-metrics.jsonl

# Find largest build
jq -s 'max_by(.amd64_size_mb | tonumber)' build-metrics.jsonl
```

### Analyze Specific Version

```bash
# View full report
cat metrics-0.1.5.json | jq '.'

# View markdown report
cat metrics-0.1.5.md

# Analyze layer breakdown
cat layers-0.1.5.json | jq '.layers | sort_by(.size_bytes) | reverse | .[0:5]'
```

## 🚀 Automation

Metrics are automatically collected by the [metrics workflow](../.github/workflows/metrics.yml):

- **Trigger**: On every push to main/master and on tagged releases
- **Collection**: Image size, layer breakdown, build metadata
- **Publishing**: Uploaded as GitHub Actions artifacts
- **History**: Appended to `build-metrics.jsonl`

### Manual Trigger

You can manually trigger metrics collection:

1. Go to **Actions** → **📈 Collect Build Metrics & Observability Data**
2. Click **Run workflow**
3. Optionally enable **commit_metrics** to commit results to the repository

## 📝 Format Specification

### JSONL Format (build-metrics.jsonl)

Each line is a valid JSON object:

```json
{
  "version": "0.1.5",
  "timestamp": "2025-12-13T05:00:00Z",
  "commit": "abc123...",
  "amd64_size_mb": "123.45",
  "amd64_virtual_size_mb": "456.78",
  "amd64_layer_count": 12,
  "arm64_tar_size_mb": "125.67"
}
```

### Full Report Format (metrics-{version}.json)

```json
{
  "version": "0.1.5",
  "timestamp": "2025-12-13T05:00:00Z",
  "commit": "abc123...",
  "commit_short": "abc123",
  "ref": "refs/tags/v0.1.5",
  "workflow_run_id": "123456",
  "workflow_run_number": "42",
  "build_metrics": {
    "workflow_duration_seconds": "...",
    "runner_os": "Linux",
    "runner_arch": "X64"
  },
  "image_metrics": {
    "amd64": {
      "size_bytes": 129456789,
      "size_mb": "123.45",
      "virtual_size_bytes": 478912345,
      "virtual_size_mb": "456.78",
      "layer_count": 12,
      "created": "2025-12-13T05:00:00Z"
    },
    "arm64": {
      "tar_size_bytes": 131823456,
      "tar_size_mb": "125.67"
    }
  }
}
```

## 🎯 Use Cases

### Performance Regression Detection
Monitor the `amd64_size_mb` over time to detect unexpected size increases.

### Optimization Tracking
Compare layer breakdowns before and after optimization efforts.

### Release Planning
Review metrics before tagging releases to ensure quality standards.

### Trend Analysis
Analyze historical data to understand long-term growth patterns.

## 🔗 Related Documentation

- [Release Process](../docs/release-process.md)
- [Contributing Guidelines](../CONTRIBUTING.md)
- [Metrics Workflow](../.github/workflows/metrics.yml)

---

**Note**: This directory is automatically maintained by CI/CD workflows. Manual edits are not recommended unless you know what you're doing.
