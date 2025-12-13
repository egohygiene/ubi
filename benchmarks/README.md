# ⚡ UBI Performance Benchmarks

This directory contains performance benchmarking results and historical data for the UBI container image.

## 📊 What is Benchmarked

### Container Startup Performance
- **Cold Start Time**: Time from `docker run` to shell availability (no cached layers)
- **Warm Start Time**: Time from `docker run` to shell availability (cached layers)
- **Time to First Command**: Latency for executing the first command in the container

### Resource Usage
- **CPU Usage**: CPU consumption during container startup and initialization
- **Memory Usage**: Memory footprint during startup and at idle
- **Disk I/O**: Optional disk I/O statistics during startup

### Image Size Metrics
- **Total Pulled Size**: Compressed image size (what gets downloaded)
- **Total Uncompressed Size**: Full image size on disk
- **Layer-by-Layer Breakdown**: Size contribution of each layer
- **Per-Architecture**: Separate metrics for amd64 and arm64

## 📁 Files

- **benchmark-results.jsonl**: Historical benchmark results in JSON Lines format
- **benchmark-{version}.json**: Detailed benchmark report for a specific version
- **benchmark-{version}.md**: Human-readable benchmark report for a specific version

## 🚀 Running Benchmarks

Benchmarks are automatically run by the [benchmark workflow](../.github/workflows/benchmark.yml):

- **Trigger**: Manual workflow dispatch or on tagged releases
- **Variants Tested**: All UBI variants (base, minimal, python, node, full)
- **Output**: JSON and Markdown reports uploaded as artifacts

### Manual Trigger

1. Go to **Actions** → **⚡ Performance Benchmarking**
2. Click **Run workflow**
3. Select the branch to test (default: main)
4. Optionally enable **commit_results** to commit benchmark data to the repository

### Local Testing

You can run benchmarks locally for development:

```bash
# Build the image
docker build -f .devcontainer/Dockerfile -t ubi:test .

# Measure cold start time (clear cache first)
docker system prune -af
time docker run --rm ubi:test echo "Ready"

# Measure warm start time (layers cached)
time docker run --rm ubi:test echo "Ready"

# Monitor resource usage
docker stats --no-stream $(docker run -d ubi:test sleep 10)
```

## 📋 Benchmark Format

### JSONL Format (benchmark-results.jsonl)

Each line is a valid JSON object representing one benchmark run:

```json
{
  "version": "0.1.5",
  "variant": "base",
  "timestamp": "2025-12-13T06:00:00Z",
  "commit": "abc123...",
  "architecture": "amd64",
  "startup_times": {
    "cold_start_seconds": 1.234,
    "warm_start_seconds": 0.567,
    "first_command_seconds": 0.123
  },
  "resource_usage": {
    "cpu_percent": 2.5,
    "memory_mb": 45.6,
    "memory_limit_mb": 1024.0
  },
  "image_metrics": {
    "size_mb": 123.45,
    "virtual_size_mb": 456.78,
    "layer_count": 12
  }
}
```

### Full Report Format (benchmark-{version}.json)

Comprehensive benchmark results with metadata:

```json
{
  "version": "0.1.5",
  "timestamp": "2025-12-13T06:00:00Z",
  "commit": "abc123...",
  "ref": "refs/tags/v0.1.5",
  "workflow_run_id": "123456",
  "variants": {
    "base": {
      "amd64": {
        "startup_times": {...},
        "resource_usage": {...},
        "image_metrics": {...}
      },
      "arm64": {...}
    },
    "minimal": {...},
    "python": {...}
  }
}
```

## 📈 Use Cases

### Regression Detection
Monitor startup times and resource usage to detect performance regressions between releases.

### Optimization Validation
Compare benchmarks before and after optimization changes to measure improvements.

### Variant Comparison
Compare performance characteristics across different UBI variants (minimal vs full).

### Architecture Comparison
Understand performance differences between amd64 and arm64 architectures.

### Capacity Planning
Use resource usage data for infrastructure planning and resource allocation.

## 🎯 Performance Targets

These are informal goals, not strict requirements:

| Metric | Target | Rationale |
|--------|--------|-----------|
| Cold Start Time | < 3s | Fast developer feedback loop |
| Warm Start Time | < 1s | Instant development iteration |
| Memory at Idle | < 100 MB | Efficient resource utilization |
| Image Size (compressed) | < 500 MB | Reasonable download time |

## 📊 Analyzing Results

### View Latest Benchmark

```bash
# View latest result
tail -1 benchmarks/benchmark-results.jsonl | jq '.'

# View specific version
cat benchmarks/benchmark-0.1.5.json | jq '.'
```

### Compare Performance Over Time

```bash
# Extract startup times over history
jq -r '[.version, .timestamp, .startup_times.cold_start_seconds] | @tsv' \
  benchmarks/benchmark-results.jsonl

# Find slowest startup
jq -s 'max_by(.startup_times.cold_start_seconds)' \
  benchmarks/benchmark-results.jsonl

# Average startup time
jq -s 'map(.startup_times.cold_start_seconds) | add/length' \
  benchmarks/benchmark-results.jsonl
```

### Compare Variants

```bash
# Compare base vs minimal (from full report)
jq '.variants.base.amd64.startup_times, .variants.minimal.amd64.startup_times' \
  benchmarks/benchmark-0.1.5.json
```

## 🔗 Related Documentation

- [Architecture Documentation](../docs/architecture.md)
- [Release Process](../docs/release-process.md)
- [Metrics Collection](../metrics/README.md)
- [Contributing Guidelines](../CONTRIBUTING.md)

## 🛠️ Troubleshooting

### Inconsistent Results

Benchmark results can vary due to:
- GitHub Actions runner load
- Network conditions (for image pulls)
- Docker cache state
- Background processes

**Solution**: Run benchmarks multiple times and average results.

### Missing Data

If some metrics are missing:
- Check the workflow logs for errors
- Ensure Docker stats collection is enabled
- Verify the container starts successfully

### Comparing to Local Results

GitHub Actions runners may have different performance characteristics than your local machine. For fair comparisons:
- Always compare within the same environment
- Focus on relative changes between versions
- Use CI results as the canonical benchmark

---

**Note**: This directory is automatically maintained by CI/CD workflows. Manual edits to result files are not recommended.
