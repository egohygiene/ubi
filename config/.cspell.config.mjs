import { defineConfig } from "cspell";
import { dirname, resolve, relative } from "path";
import { fileURLToPath } from "url";

// Timestamp for unique report filenames
const utcTimestamp = Math.floor(Date.now() / 1000);

// Get the project root directory
function getProjectRoot() {
    // __dirname is not available in ES modules, so use fileURLToPath
    const currentFile = fileURLToPath(import.meta.url);
    // The config file is at the project root
    const configDir = dirname(currentFile);
    return dirname(configDir);
}
console.log(`Project root directory: ${getProjectRoot()}`);

// Directory where custom dictionaries are stored
const dictionariesDir = resolve(getProjectRoot(), ".vscode/dictionaries");
console.log(`Dictionaries directory: ${dictionariesDir}`);

// Directory where reports will be saved
const reportsDir = relative(
    process.cwd(),
    resolve(getProjectRoot(), "reports/cspell"),
);
console.log(`Reports directory: ${reportsDir}`);

// Directory where cache will be stored
const cacheDir = resolve(getProjectRoot(), ".cache/cspell");
console.log(`Cache directory: ${cacheDir}`);

// Define the CSpell configuration
/**
 *  @type { import('cspell').CSpellSettings }
 *  @see https://cspell.org/docs/Configuration/properties
 */
export default defineConfig({
    $schema:
        "https://raw.githubusercontent.com/streetsidesoftware/cspell/main/cspell.schema.json",
    version: "0.2",
    language: "en",
    name: "Project CSpell Configuration",
    description: "CSpell configuration for the project",
    enabled: true,
    allowCompoundWords: false,
    caseSensitive: false,
    userWords: ["cspell"],
    globRoot: ".",
    files: [
        "src/**/*.{ts,tsx,js,jsx,vue}", // Frontend source
        "scripts/**/*.{ts,js,sh}", // Utility scripts
        "tests/**/*.{ts,tsx,js,jsx}", // Tests
        "**/*.{md,markdown}", // Markdown
        "**/*.{json,yaml,yml}", // Config files
        "**/*.{html,css,scss,less}", // Web styles/templates
        ".github/**/*.{yml,yaml}", // GitHub Actions
        "*.{md,json,yml}", // Root files
        "*.{toml,txt}", // Other project files
    ],
    enableGlobDot: true,
    ignorePaths: [
        `${dictionariesDir}/**/*.dictionary`, // Ignore custom dictionaries
        "/backend-terms.txt",
        "**/.cache/**",
        "**/.git/**",
        "**/.next/**",
        "**/.spectral.yaml",
        "**/.turbo/**",
        "**/.vercel/**",
        "**/.vscode/**",
        "**/.venv/**",
        "**/bin/**",
        "**/bower_components/**",
        "**/build/**",
        "**/coverage/**",
        "**/dist/**",
        "**/logs/**",
        "**/log/**",
        "**/node_modules/**",
        "**/out/**",
        "**/output/**",
        "**/package-lock.json",
        "**/package.json",
        "**/pnpm-lock.yaml",
        "**/reports/**",
        "**/target/**",
        "**/temp/**",
        "**/tmp/**",
        "**/vendor/**",
        "**/venv/**",
        "**/vscode-extension/**",
        "**/yarn.lock",
        "**/*.drawio",
        "**/*.gif",
        "**/*.ico",
        "**/*.jpeg",
        "**/*.jpg",
        "**/*.log",
        "**/*.min.js",
        "**/*.png",
        "**/*.svg",
        "**/*.ttf",
        "**/*.woff",
        "**/*.webp",
        "**/*.otf",
        "**/*.lock",
    ],
    noConfigSearch: true,
    readonly: false,
    reporters: [
        "default",
        [
            "@cspell/cspell-json-reporter",
            {
                outFile: `${reportsDir}/cspell-report-${utcTimestamp}.json`,
            },
        ],
    ],
    useGitignore: true,
    gitignoreRoot: [],
    validateDirectives: true,
    dictionaryDefinitions: [
        {
            name: "project-words",
            path: resolve(dictionariesDir, "project-words.dictionary"),
            addWords: true,
        },
        {
            name: "backend-terms",
            path: resolve(dictionariesDir, "backend-terms.dictionary"),
            addWords: false,
        },
        {
            name: "devops-cloud-terms",
            path: resolve(dictionariesDir, "devops-cloud-terms.dictionary"),
            addWords: false,
        },
        {
            name: "frontend-terms",
            path: resolve(dictionariesDir, "frontend-terms.dictionary"),
            addWords: false,
        },
        {
            name: "programming-terms",
            path: resolve(dictionariesDir, "programming-terms.dictionary"),
            addWords: false,
        },
        {
            name: "software-terms",
            path: resolve(dictionariesDir, "software-terms.dictionary"),
            addWords: false,
        },
    ],
    dictionaries: [
        "project-words",
        "backend-terms",
        "devops-cloud-terms",
        "frontend-terms",
        "programming-terms",
        "software-terms",
    ],
    cache: {
        useCache: true,
        cacheLocation: cacheDir,
        cacheStrategy: "content",
        cacheFormat: "universal",
    },
    failFast: true,
    loadDefaultConfiguration: true,
});
