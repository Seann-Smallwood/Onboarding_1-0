import js from "@eslint/js";
import globals from "globals";
import tseslint from "typescript-eslint";

export default [
  // Apply ESLint recommended rules to JavaScript files
  {
    files: ["**/*.{js,mjs,cjs}"],
    ...js.configs.recommended,
    languageOptions: { 
      globals: globals.node 
    },
  },

  // Apply TypeScript ESLint recommended rules to TypeScript files
  ...tseslint.configs.recommended.map(config => ({
    ...config,
    files: ["**/*.{ts,mts,cts}"],
  })),

  // Custom rules for TypeScript files
  {
    files: ["**/*.{ts,mts,cts}"],
    languageOptions: {
      globals: globals.node,
    },
    rules: {
      // Example custom rules
      "@typescript-eslint/no-explicit-any": "warn",
      "@typescript-eslint/explicit-function-return-type": "off",
      "@typescript-eslint/no-unused-vars": ["error", { "argsIgnorePattern": "^_" }],
    },
  },

  // Ignore files
  {
    ignores: ["lib/**", "coverage/**", "node_modules/**", "public/**"],
  },
];
