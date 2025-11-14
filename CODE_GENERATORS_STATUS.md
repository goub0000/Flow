# Code Generators Status

## Disabled Generators

The following code generation dependencies are currently **disabled** in `pubspec.yaml`:

```yaml
# riverpod_generator: ^2.3.9  # Temporarily disabled due to analyzer_plugin conflict
# riverpod_lint: ^2.3.7        # Temporarily disabled due to analyzer_plugin conflict
```

## Reason for Disabling

These packages were disabled due to conflicts with the `analyzer_plugin` system in Dart/Flutter. The conflict typically manifests as:

- Build failures during `flutter pub get`
- Analysis server crashes
- IDE (VS Code/Android Studio) not recognizing generated code
- Conflicts with other code generation tools (freezed, json_serializable)

## Current Workaround

The project currently uses:
- **Manual Riverpod providers** instead of generated providers
- **freezed** for immutable data classes (still enabled)
- **json_serializable** for JSON serialization (still enabled)
- **build_runner** for running other code generators

## Impact

Without `riverpod_generator`:
- Providers must be manually written instead of using `@riverpod` annotations
- More boilerplate code for state management
- No automatic code generation for providers
- Manual dependency management between providers

Without `riverpod_lint`:
- Missing lint rules specific to Riverpod best practices
- Potential for common Riverpod mistakes (e.g., forgetting to watch providers)
- No IDE warnings for Riverpod-specific issues

## Re-enabling Steps

To re-enable these generators when the conflicts are resolved:

1. **Uncomment the dependencies in `pubspec.yaml`:**
   ```yaml
   dev_dependencies:
     riverpod_generator: ^2.3.9
     riverpod_lint: ^2.3.7
   ```

2. **Update to latest versions:**
   ```bash
   flutter pub upgrade
   ```

3. **Run code generation:**
   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

4. **Test for conflicts:**
   - Check if `flutter analyze` completes without errors
   - Verify IDE recognizes generated code
   - Run a sample build to ensure no conflicts

5. **Update provider code:**
   - Migrate manual providers to use `@riverpod` annotations
   - Run build_runner to generate provider implementations
   - Update imports to use generated files

## Alternative Solutions

If conflicts persist:

1. **Use manual Riverpod providers** (current approach)
   - More verbose but fully functional
   - No dependency on code generation
   - Easier to debug and understand

2. **Update analyzer_plugin versions**
   - Check for updates to analyzer_plugin packages
   - Update Dart SDK version if needed
   - Check Riverpod releases for compatibility fixes

3. **Isolate code generation**
   - Run code generators in separate packages
   - Use a monorepo structure to isolate dependencies
   - Generate code in a pre-build step

## Status Tracking

- **Last Checked:** January 2025
- **Current Workaround:** Manual providers (stable)
- **Blocking Issues:** analyzer_plugin conflicts
- **Next Review:** Check with Flutter 3.x updates and Riverpod 3.x

## Related Issues

- Flutter analyzer_plugin compatibility
- Riverpod code generation conflicts with other generators
- Build_runner version compatibility

## Recommendations

For now, **continue using manual providers** until:
1. Flutter SDK updates resolve analyzer_plugin issues
2. Riverpod releases fix for generator conflicts
3. Project requires significant scaling that justifies migration effort

The manual approach is stable and maintainable for the current project size.
