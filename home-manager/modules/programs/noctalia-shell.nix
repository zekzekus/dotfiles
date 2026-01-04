{ ... }:

{
  programs.noctalia-shell = {
    enable = true;
    systemd.enable = true;
    settings = {
      appLauncher = {
        customLaunchPrefix = "uwsm-app --";
        customLaunchPrefixEnabled = true;
        enableClipPreview = false;
        enableClipboardHistory = true;
        iconMode = "tabler";
        ignoreMouseInput = false;
        pinnedExecs = [ ];
        screenshotAnnotationTool = "";
        position = "center";
        showIconBackground = true;
        showCategories = false;
        sortByMostUsed = true;
        terminalCommand = "ghostty -e";
        useApp2Unit = false;
        viewMode = "list";
      };

      audio = {
        cavaFrameRate = 30;
        externalMixer = "pwvucontrol || pavucontrol";
        mprisBlacklist = [ ];
        preferredPlayer = "";
        visualizerType = "linear";
        volumeOverdrive = false;
        volumeStep = 5;
      };

      bar = {
        backgroundOpacity = 0.65;
        capsuleOpacity = 0.75;
        density = "comfortable";
        exclusive = true;
        floating = false;
        marginHorizontal = 0.25;
        marginVertical = 0.25;
        monitors = [ ];
        outerCorners = true;
        position = "top";
        showCapsule = true;
        showOutline = false;
        useSeparateOpacity = true;
        widgets = {
          center = [
            {
              id = "ActiveWindow";
              colorizeIcons = false;
              hideMode = "hidden";
              maxWidth = 145;
              scrollingMode = "hover";
              showIcon = true;
              useFixedWidth = false;
            }
            {
              id = "MediaMini";
              hideMode = "hidden";
              hideWhenIdle = false;
              maxWidth = 145;
              scrollingMode = "hover";
              showAlbumArt = false;
              showArtistFirst = true;
              showProgressRing = true;
              showVisualizer = false;
              useFixedWidth = false;
              visualizerType = "linear";
            }
          ];
          left = [
            {
              id = "CustomButton";
              colorizeSystemIcon = "none";
              enableColorization = false;
              hideMode = "alwaysExpanded";
              icon = "rocket";
              leftClickExec = "noctalia-shell ipc call launcher toggle";
              leftClickUpdateText = false;
              maxTextLength = {
                horizontal = 10;
                vertical = 10;
              };
              middleClickExec = "";
              middleClickUpdateText = false;
              parseJson = false;
              rightClickExec = "";
              rightClickUpdateText = false;
              showIcon = true;
              textCollapse = "";
              textCommand = "";
              textIntervalMs = 3000;
              textStream = false;
              wheelDownExec = "";
              wheelDownUpdateText = false;
              wheelExec = "";
              wheelMode = "unified";
              wheelUpExec = "";
              wheelUpUpdateText = false;
              wheelUpdateText = false;
            }
            {
              id = "Workspace";
              characterCount = 2;
              colorizeIcons = false;
              enableScrollWheel = true;
              followFocusedScreen = false;
              groupedBorderOpacity = 1;
              hideUnoccupied = false;
              iconScale = 0.8;
              labelMode = "none";
              showApplications = false;
              showLabelsOnlyWhenOccupied = true;
              unfocusedIconsOpacity = 1;
            }
          ];
          right = [
            {
              id = "NotificationHistory";
              hideWhenZero = false;
              showUnreadBadge = true;
            }
            {
              id = "SystemMonitor";
              compactMode = true;
              diskPath = "/";
              showCpuTemp = true;
              showCpuUsage = true;
              showDiskUsage = true;
              showGpuTemp = false;
              showLoadAverage = false;
              showMemoryAsPercent = true;
              showMemoryUsage = true;
              showNetworkStats = false;
              useMonospaceFont = true;
              usePrimaryColor = false;
            }
            {
              id = "ScreenRecorder";
            }
            {
              id = "Tray";
              blacklist = [ ];
              colorizeIcons = false;
              drawerEnabled = true;
              hidePassive = false;
              pinned = [
                "1Password"
              ];
            }
            {
              id = "Battery";
              deviceNativePath = "";
              displayMode = "onhover";
              hideIfNotDetected = true;
              showNoctaliaPerformance = false;
              showPowerProfiles = false;
              warningThreshold = 30;
            }
            {
              id = "Volume";
              displayMode = "onhover";
            }
            {
              id = "Brightness";
              displayMode = "onhover";
            }
            {
              id = "Clock";
              customFont = "";
              formatHorizontal = "HH:mm ddd, MMM dd";
              formatVertical = "HH mm - dd MM";
              tooltipFormat = "HH:mm ddd, MMM dd";
              useCustomFont = false;
              usePrimaryColor = false;
            }
            {
              id = "ControlCenter";
              colorizeDistroLogo = false;
              colorizeSystemIcon = "none";
              customIconPath = "";
              enableColorization = false;
              icon = "noctalia";
              useDistroLogo = false;
            }
          ];
        };
      };

      brightness = {
        brightnessStep = 5;
        enableDdcSupport = true;
        enforceMinimum = true;
      };

      calendar = {
        cards = [
          { enabled = true; id = "calendar-header-card"; }
          { enabled = true; id = "calendar-month-card"; }
          { enabled = true; id = "timer-card"; }
          { enabled = true; id = "weather-card"; }
        ];
      };

      colorSchemes = {
        darkMode = true;
        generateTemplatesForPredefined = true;
        manualSunrise = "06:30";
        manualSunset = "18:30";
        matugenSchemeType = "scheme-tonal-spot";
        predefinedScheme = "Kanagawa";
        schedulingMode = "off";
        useWallpaperColors = false;
      };

      controlCenter = {
        cards = [
          { enabled = true; id = "profile-card"; }
          { enabled = true; id = "shortcuts-card"; }
          { enabled = true; id = "audio-card"; }
          { enabled = true; id = "weather-card"; }
          { enabled = true; id = "media-sysmon-card"; }
          { enabled = false; id = "brightness-card"; }
        ];
        diskPath = "/";
        position = "top_center";
        shortcuts = {
          left = [
            { id = "WiFi"; }
            { id = "Bluetooth"; }
            { id = "ScreenRecorder"; }
            { id = "WallpaperSelector"; }
          ];
          right = [
            { id = "Notifications"; }
            { id = "PowerProfile"; }
            { id = "KeepAwake"; }
            { id = "NightLight"; }
          ];
        };
      };

      desktopWidgets = {
        enabled = false;
        gridSnap = false;
        monitorWidgets = [
          {
            name = "HDMI-A-2";
            widgets = [];
          }
        ];
      };

      dock = {
        animationSpeed = 1;
        enabled = false;
        backgroundOpacity = 1;
        colorizeIcons = false;
        deadOpacity = 0.6;
        displayMode = "auto_hide";
        floatingRatio = 1;
        inactiveIndicators = false;
        monitors = [ ];
        onlySameOutput = true;
        pinnedApps = [ ];
        pinnedStatic = false;
        size = 1;
      };

      general = {
        allowPanelsOnScreenWithoutBar = true;
        animationDisabled = false;
        animationSpeed = 1;
        avatarImage = "~/.face";
        boxRadiusRatio = 1;
        compactLockScreen = false;
        dimmerOpacity = 0.6;
        enableShadows = true;
        forceBlackScreenCorners = false;
        iRadiusRatio = 1;
        language = "";
        lockOnSuspend = true;
        radiusRatio = 1;
        scaleRatio = 1;
        screenRadiusRatio = 1;
        shadowDirection = "bottom_right";
        shadowOffsetX = 2;
        shadowOffsetY = 3;
        showHibernateOnLockScreen = false;
        showScreenCorners = false;
        showSessionButtonsOnLockScreen = true;
      };

      hooks = {
        darkModeChange = "";
        enabled = false;
        performanceModeDisabled = "";
        performanceModeEnabled = "";
        screenLock = "";
        screenUnlock = "";
        wallpaperChange = "";
      };

      location = {
        analogClockInCalendar = false;
        firstDayOfWeek = -1;
        name = "Istanbul";
        showCalendarEvents = true;
        showCalendarWeather = true;
        showWeekNumberInCalendar = false;
        use12hourFormat = false;
        useFahrenheit = false;
        weatherEnabled = true;
        weatherShowEffects = true;
      };

      network = {
        bluetoothDetailsViewMode = "grid";
        bluetoothHideUnnamedDevices = false;
        bluetoothRssiPollIntervalMs = 10000;
        bluetoothRssiPollingEnabled = false;
        wifiDetailsViewMode = "grid";
        wifiEnabled = true;
      };

      nightLight = {
        enabled = true;
        autoSchedule = true;
        dayTemp = "6500";
        forced = false;
        manualSunrise = "06:30";
        manualSunset = "18:30";
        nightTemp = "4000";
      };

      notifications = {
        enabled = true;
        backgroundOpacity = 1;
        criticalUrgencyDuration = 15;
        enableKeyboardLayoutToast = true;
        location = "top_right";
        lowUrgencyDuration = 3;
        monitors = [ ];
        normalUrgencyDuration = 8;
        overlayLayer = true;
        respectExpireTimeout = false;
        saveToHistory = {
          critical = true;
          low = true;
          normal = true;
        };
        sounds = {
          enabled = false;
          criticalSoundFile = "";
          excludedApps = "discord,firefox,chrome,chromium,edge";
          lowSoundFile = "";
          normalSoundFile = "";
          separateSounds = false;
          volume = 0.5;
        };
      };

      osd = {
        enabled = true;
        autoHideMs = 2000;
        backgroundOpacity = 1;
        enabledTypes = [ 0 1 2 ];
        location = "top_right";
        monitors = [ ];
        overlayLayer = true;
      };

      screenRecorder = {
        audioCodec = "opus";
        audioSource = "default_output";
        colorRange = "limited";
        copyToClipboard = false;
        directory = "~/Videos";
        frameRate = 60;
        quality = "very_high";
        showCursor = true;
        videoCodec = "h264";
        videoSource = "portal";
      };

      sessionMenu = {
        countdownDuration = 10000;
        enableCountdown = true;
        largeButtonsLayout = "grid";
        largeButtonsStyle = true;
        position = "center";
        powerOptions = [
          { action = "lock"; enabled = true; command = ""; countdownEnabled = true; }
          { action = "suspend"; enabled = false; command = ""; countdownEnabled = true; }
          { action = "hibernate"; enabled = false; command = ""; countdownEnabled = true; }
          { action = "reboot"; enabled = true; command = ""; countdownEnabled = true; }
          { action = "logout"; enabled = true; command = ""; countdownEnabled = true; }
          { action = "shutdown"; enabled = true; command = ""; countdownEnabled = true; }
        ];
        showHeader = true;
        showNumberLabels = true;
      };

      settingsVersion = 37;

      systemMonitor = {
        cpuCriticalThreshold = 90;
        cpuPollingInterval = 3000;
        cpuWarningThreshold = 80;
        criticalColor = "";
        diskCriticalThreshold = 90;
        diskPollingInterval = 3000;
        diskWarningThreshold = 80;
        enableDgpuMonitoring = false;
        externalMonitor = "resources || missioncenter || jdsystemmonitor || corestats || system-monitoring-center || gnome-system-monitor || plasma-systemmonitor || mate-system-monitor || ukui-system-monitor || deepin-system-monitor || pantheon-system-monitor";
        gpuCriticalThreshold = 90;
        gpuPollingInterval = 3000;
        gpuWarningThreshold = 80;
        loadAvgPollingInterval = 3000;
        memCriticalThreshold = 90;
        memPollingInterval = 3000;
        memWarningThreshold = 80;
        networkPollingInterval = 3000;
        tempCriticalThreshold = 90;
        tempPollingInterval = 3000;
        tempWarningThreshold = 80;
        useCustomColors = false;
        warningColor = "";
      };

      templates = {
        alacritty = false;
        cava = false;
        code = false;
        discord = false;
        emacs = false;
        enableUserTemplates = false;
        foot = false;
        fuzzel = false;
        ghostty = true;
        gtk = true;
        helix = true;
        hyprland = true;
        kcolorscheme = true;
        kitty = false;
        mango = false;
        niri = false;
        pywalfox = false;
        qt = true;
        spicetify = false;
        telegram = false;
        vicinae = false;
        walker = false;
        wezterm = false;
        yazi = true;
        zed = true;
        zenBrowser = false;
      };

      ui = {
        boxBorderEnabled = false;
        fontDefault = "DejaVu Sans";
        fontDefaultScale = 1;
        fontFixed = "JetBrains Mono NL";
        fontFixedScale = 1;
        panelBackgroundOpacity = 1;
        panelsAttachedToBar = true;
        settingsPanelMode = "centered";
        tooltipsEnabled = true;
      };

      wallpaper = {
        enabled = true;
        directory = "~/Pictures/Wallpapers";
        enableMultiMonitorDirectories = false;
        fillColor = "#000000";
        fillMode = "crop";
        hideWallpaperFilenames = false;
        monitorDirectories = [ ];
        overviewEnabled = false;
        panelPosition = "follow_bar";
        randomEnabled = false;
        randomIntervalSec = 300;
        recursiveSearch = false;
        setWallpaperOnAllMonitors = true;
        solidColor = "#1a1a2e";
        transitionDuration = 1500;
        transitionEdgeSmoothness = 0.05;
        transitionType = "random";
        useSolidColor = false;
        useWallhaven = false;
        wallhavenApiKey = "";
        wallhavenCategories = "111";
        wallhavenOrder = "desc";
        wallhavenPurity = "100";
        wallhavenQuery = "";
        wallhavenRatios = "";
        wallhavenResolutionHeight = "";
        wallhavenResolutionMode = "atleast";
        wallhavenResolutionWidth = "";
        wallhavenSorting = "relevance";
        wallpaperChangeMode = "random";
      };
    };
  };
}
