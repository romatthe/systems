import Control.Arrow (first)
import qualified Data.Map as M
import System.Exit (exitSuccess)
import XMonad hiding ((|||))
import XMonad.Actions.Navigation2D
  ( Direction2D (L, R),
    windowGo,
    withNavigation2DConfig,
  )
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.EwmhDesktops
  ( ewmh,
    fullscreenEventHook,
  )
import XMonad.Hooks.ManageDocks
  ( avoidStruts,
    docks,
  )
import XMonad.Hooks.ManageHelpers
  ( doFullFloat,
    isFullscreen,
  )
import XMonad.Layout.BinarySpacePartition
  ( Rotate (Rotate),
    Swap (Swap),
    emptyBSP,
  )
import XMonad.Layout.LayoutCombinators
  ( JumpToLayout (JumpToLayout),
    (|||),
  )
import XMonad.Layout.NoBorders (smartBorders)
import XMonad.Layout.Spacing
  ( Border (Border),
    spacingRaw,
  )
import XMonad.Layout.Spiral (spiral)
import XMonad.Prompt
import XMonad.Prompt.ConfirmPrompt (confirmPrompt)
import XMonad.Prompt.FuzzyMatch (fuzzyMatch)
import XMonad.Prompt.Man (manPrompt)
import XMonad.Prompt.Shell (shellPrompt)
import XMonad.Prompt.Unicode (mkUnicodePrompt)
import qualified XMonad.StackSet as W
import XMonad.Util.Cursor (setDefaultCursor)
import XMonad.Util.EZConfig (additionalKeysP)
import XMonad.Util.NamedScratchpad
import XMonad.Util.Run
  ( hPutStrLn,
    spawnPipe,
  )
import XMonad.Util.SpawnOnce (spawnOnce)

main :: IO ()
main = do
  xmonad $ docks $ withNavigation2DConfig def $ ewmh
    def { handleEventHook = handleEventHook def <+> fullscreenEventHook }
      {
      -- simple stuff
        terminal           = defTerminal
      , focusFollowsMouse  = myFocusFollowsMouse
      , clickJustFocuses   = myClickJustFocuses
      , borderWidth        = myBorderWidth
      , modMask            = myModMask
      , workspaces         = myWorkspaces
      , normalBorderColor  = myNormalBorderColor
      , focusedBorderColor = myFocusedBorderColor
      -- key bindings
      -- , keys               = myKeys
      , mouseBindings      = myMouseBindings
      -- hooks, layouts
      , layoutHook         = myLayout
      , manageHook         = myManageHook
      , handleEventHook    = myEventHook
      , logHook            = myLogHook h
      , startupHook        = myStartupHook
      } `additionalKeysP` myKeys

-- Default terminal
defTerminal :: String
defTerminal = "alacritty"

-- Super key as the mod key
defModMask :: KeyMask
defModMask = mod4Mask

-- Gaps
defGaps = spacingRaw False (Border 4 4 4 4) True (Border 4 4 4 4) True

--  Set workspace names to zero-width space. This makes possible to show workspaces as nerd font orb symbol in xmobar
defWorkspaces :: [String]
defWorkspaces =
  [ "1",
    "2",
    "3",
    "4",
    "5",
    "6",
    "7",
    "8",
    "9"
  ]

-- Keybindings
defKeys :: [(String, X ())]
defKeys =
  [ ("M-<Return>", spawn defTerminal),
    -- Show the Rofi application launcher
    ("C-<Space>", spawn "rofi -show drun"),
    -- Close focused application
    ("M-q", kill),
    -- Lock screen
    ("M-l", spawn "light-locker-command -l"),
    -- Prompt to kill Xmonad
    ("M-S-q", confirmPrompt defaultXPConfig "exit" $ io exitSuccess),
    -- Recompile and restart xmonad
    ("M-S-r", spawn "xmonad --recompile; xmonad --restart"),
    --("M-z", spawn "emacsclient -c -a emacs ~/"),
    --("M-w", spawn "emacsclient -c -a emacs"),
    ("M-b", spawn "firefox"),
    --("M-e", spawn "~/.emacs_anywhere/bin/run"),
    --("M-C-t", namedScratchpadAction myScratchPads "terminal"),
    --("M-C-s", namedScratchpadAction myScratchPads "mixer"),
    --("M-C-h", namedScratchpadAction myScratchPads "bottom"),
    --("M-C-n", namedScratchpadAction myScratchPads "vifm"),
    --("M-d", shellPrompt myXPConfig),
    --("M-C-m", manPrompt myXPConfig),
    --("M-C-e", mkUnicodePrompt "xsel" ["-b"] "/etc/UnicodeData.txt" myEmojiXPConfig), -- copy emoji to clipboard
    --("<XF86AudioLowerVolume>", spawn "amixer -q sset Master 2%-"), -- fn+a on HHKB Dvorak
    --("<XF86AudioRaiseVolume>", spawn "amixer -q sset Master 2%+"), -- fn+o on HHKB Dvorak
    --("<XF86AudioMute>", spawn "amixer set Master toggle"), -- fn+e on HHKB Dvorak
    --("<XF86MonBrightnessUp>", spawn "xbacklight -inc 5"),
    --("<XF86MonBrightnessDown>", spawn "xbacklight -dec 5"),
    --("C-<Print>", spawn "scrot -s screen_%Y-%m-%d-%H-%M-%S.png -e 'mv $f ~/Pictures/'"), -- ctrl+fn+c on HHKB Dvorak
    --("M-<Print>", spawn "scrot tmp.png -e 'xclip $f && rm $f'"), -- mod+fn+c on HHKB Dvorak
    -- Change to next layout in order
    ("M-<Space>", sendMessage NextLayout),
    --("M-t", sendMessage $ JumpToLayout "Spacing Tall"),
    --("M-f", sendMessage $ JumpToLayout "Full"),
    --("M-m", sendMessage $ JumpToLayout "Mirror Spacing Tall"),
    --("M-n", sendMessage $ JumpToLayout "Spacing BSP"),
    --("M-s", sendMessage $ JumpToLayout "Spacing Spiral"),
    --("M-S-t", withFocused $ windows . W.sink), -- unfloat window
    --("M-r", refresh),
    -- focus horizontally like i3wm
    --("M-h", windowGo L False),
    --("M-l", windowGo R False),
    --("M-j", windows W.focusDown),
    --("M-k", windows W.focusUp),
    --("M-g", windows W.focusMaster),
    --("M-S-j", windows W.swapDown),
    --("M-S-k", windows W.swapUp),
    --("M-S-g", windows W.swapMaster),
    --("M-S-h", sendMessage Shrink),
    --("M-S-l", sendMessage Expand),
    --( "M-,",
    --  do
    --    layout <- getActiveLayoutDescription
    --    case layout of
    --      "Spacing BSP" -> sendMessage Swap
    --      _ -> sendMessage $ IncMasterN 1
    --),
    --( "M-.",
    --  do
    --    layout <- getActiveLayoutDescription
    --    case layout of
    --      "Spacing BSP" -> sendMessage Rotate
    --      _ -> sendMessage $ IncMasterN (-1)
    --)
  ]

defLayout = avoidStruts $ smartBorders
  (tiledgaps ||| bspgaps ||| Mirror tiledgaps ||| spiralgaps ||| Full)
 where
  tiledgaps  = defGaps $ Tall nmaster delta ratio

  -- window number in master pane
  nmaster    = 1

  -- percent of screen to increment by when resizing panes
  delta      = 2 / 100

  -- default proportion of screen occupied by master pane
  ratio      = 1 / 2

  bspgaps    = defGaps emptyBSP
  spiralgaps = defGaps $ spiral (6 / 7)

defStartupHook = do
  -- TODO: Fix this
  --spawnOnce "feh --bg-fill /etc/wallpapers/wallpaper1.png &"
  -- TODO: Fix this
  --spawnOnce "nitrogen --restore &"
  setDefaultCursor xC_left_ptr
  -- start screen locker
  -- TODO: Fix this
  --spawnOnce "light-locker --lock-on-suspend &"
  -- window animation
  -- TODO: Fix this
  --spawnOnce "flashfocus &"

  
