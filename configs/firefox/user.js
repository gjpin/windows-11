// Disable View feature
user_pref("browser.tabs.firefox-view", false);

// Disable List All Tabs button
user_pref("browser.tabs.tabmanager.enabled", false);

// Disable password manager
user_pref("signon.rememberSignons", false);

// Disable Mozilla telemetry/experiments
user_pref("toolkit.telemetry.enabled", false);
user_pref("toolkit.telemetry.unified", false);
user_pref("toolkit.telemetry.archive.enabled", false);
user_pref("experiments.supported", false);
user_pref("experiments.enabled", false);
user_pref("experiments.manifest.uri", "");

// Disallow Necko to do A/B testing
user_pref("network.allow-experiments", false);

// Disable Pocket
user_pref("browser.pocket.enabled", false);
user_pref("extensions.pocket.enabled", false);
user_pref("browser.newtabpage.activity-stream.feeds.section.topstories", false);

// Disable sending Firefox crash reports to Mozilla servers
user_pref("breakpad.reportURL", "");

// Disable sending reports of tab crashes to Mozilla
user_pref("browser.tabs.crashReporting.sendReport", false);
user_pref("browser.crashReports.unsubmittedCheck.enabled", false);

// Disable Shield/Heartbeat/Normandy
user_pref("app.normandy.enabled", false);
user_pref("app.normandy.api_url", "");
user_pref("extensions.shield-recipe-client.enabled", false);
user_pref("app.shield.optoutstudies.enabled", false);