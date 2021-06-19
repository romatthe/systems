import           Control.Arrow                  ( first )
import qualified Data.Map as M
import           System.Exit                    ( exitSuccess )
import           XMonad hiding ( (|||) )
import           XMonad.Actions.Navigation2D    ( Direction2D(L, R)
                                                , windowGo
                                                , withNavigation2DConfig
                                                )
import           XMonad.Hooks.DynamicLog
import           XMonad.Hooks.EwmhDesktops      ( ewmh
                                                , fullscreenEventHook
                                                )
import           XMonad.Hooks.ManageDocks       ( avoidStruts
                                                , docks
                                                )
import           XMonad.Hooks.ManageHelpers     ( doFullFloat
                                                , isFullscreen
                                                )
import           XMonad.Layout.BinarySpacePartition
                                                ( emptyBSP
                                                , Rotate(Rotate)
                                                , Swap(Swap)
                                                )
import           XMonad.Layout.LayoutCombinators
                                                ( (|||)
                                                , JumpToLayout(JumpToLayout)
                                                )
import           XMonad.Layout.NoBorders        ( smartBorders )
import           XMonad.Layout.Spacing          ( spacingRaw
                                                , Border(Border)
                                                )
import           XMonad.Layout.Spiral           ( spiral )
import           XMonad.Prompt
import           XMonad.Prompt.ConfirmPrompt    ( confirmPrompt )
import           XMonad.Prompt.FuzzyMatch       ( fuzzyMatch )
import           XMonad.Prompt.Man              ( manPrompt )
import           XMonad.Prompt.Shell            ( shellPrompt )
import           XMonad.Prompt.Unicode          ( mkUnicodePrompt )
import qualified XMonad.StackSet as W
import           XMonad.Util.Cursor             ( setDefaultCursor )
import           XMonad.Util.NamedScratchpad
import           XMonad.Util.Run                ( hPutStrLn
                                                , spawnPipe
                                                )
import           XMonad.Util.SpawnOnce          ( spawnOnce )
import           XMonad.Util.EZConfig           ( additionalKeysP )

-- Default terminal
defTerminal :: String
defTerminal = "alacritty"

--  Set workspace names to zero-width space. This makes possible to show workspaces as nerd font orb symbol in xmobar
defWorkspaces :: [String]
defWorkspaces =
  [ "\8203"
  , "\8203\8203"
  , "\8203\8203\8203"
  , "\8203\8203\8203\8203"
  , "\8203\8203\8203\8203\8203"
  , "\8203\8203\8203\8203\8203\8203"
  , "\8203\8203\8203\8203\8203\8203\8203"
  , "\8203\8203\8203\8203\8203\8203\8203\8203"
  , "\8203\8203\8203\8203\8203\8203\8203\8203\8203"
  ]

-- Show workspace names as purple/pink orb in xmobar 
defLogHook h = dynamicLogWithPP xmobarPP
  { ppOutput          = hPutStrLn h
  , ppSort            = fmap (namedScratchpadFilterOutWorkspace .) (ppSort def) -- hide nsp
  , ppCurrent         = xmobarColor "#c792ea" "" . wrap "\61713" " "  -- Current workspace
  , ppVisible         = xmobarColor "#ab47bc" "" . wrap "\61842" " "
  , ppHidden          = xmobarColor "#ab47bc" "" . wrap "\61842" " "
  , ppHiddenNoWindows = xmobarColor "#FFFFFF" "" . wrap "\61915" " "
  , ppLayout          = xmobarColor "#82aaff" ""
  , ppSep             = "  |  "
  , ppTitle           = mempty
  }
