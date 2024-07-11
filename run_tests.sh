#!/bin/bash

# Run Flutter web integration tests
flutter drive \
  --driver=test_driver/integration_test.dart \
  --target=test/sauna_session_test.dart \
  --flavor=red \
  --dart-define=flavor=red \
  -d chrome | grep ' +\| -'

# Wait for a short period to allow any async operations to complete
sleep 5

# Close Chrome browser
osascript -e 'tell application "Google Chrome" to close (tabs of windows whose title contains "Found Space")'
