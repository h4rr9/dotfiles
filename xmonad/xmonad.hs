{-# LANGUAGE AllowAmbiguousTypes #-}
{-# LANGUAGE DeriveDataTypeable #-}
{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE TypeSynonymInstances #-}

import XMonad

import XMonad.Actions.Navigation2D
import XMonad.Actions.WindowNavigation

import XMonad.Util.Font
import XMonad.Util.Loggers
import XMonad.Util.NamedScratchpad
import XMonad.Util.Paste as P
import XMonad.Util.SpawnOnce
import XMonad.Util.Ungrab

import XMonad.Layout.Accordion
import XMonad.Layout.BinarySpacePartition
import qualified XMonad.Layout.BoringWindows as BW
import XMonad.Layout.Fullscreen
import XMonad.Layout.Gaps
import XMonad.Layout.Hidden
import XMonad.Layout.IfMaxAlt
import XMonad.Layout.LimitWindows
import XMonad.Layout.MultiToggle
import XMonad.Layout.MultiToggle.Instances
import XMonad.Layout.NoBorders
import XMonad.Layout.NoFrillsDecoration
import XMonad.Layout.PerScreen
import XMonad.Layout.PerWorkspace
import XMonad.Layout.Reflect
import XMonad.Layout.Renamed
import XMonad.Layout.ResizableTile
import XMonad.Layout.ShowWName
import XMonad.Layout.Simplest
import XMonad.Layout.Spacing
import XMonad.Layout.SubLayouts
import XMonad.Layout.Tabbed
import XMonad.Layout.ThreeColumns
import XMonad.Layout.ToggleLayouts
import XMonad.Layout.WindowNavigation

import Data.Monoid
import Graphics.X11.ExtraTypes.XF86
import System.Exit

import XMonad.Hooks.DynamicLog
import XMonad.Hooks.DynamicProperty
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.InsertPosition
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.StatusBar.PP
import XMonad.Hooks.UrgencyHook
import XMonad.Hooks.WindowSwallowing

import qualified Codec.Binary.UTF8.String as UTF8
import qualified DBus as D
import qualified DBus.Client as D
import qualified Data.Map as M
import qualified XMonad.StackSet as W

-- globals

myTerminal :: String
myTerminal = "alacritty"

myBrowser :: String
myBrowser = "firefox"

myLauncher :: String
myLauncher = "~/.local/bin/myrofi"

myFocusFollowsMouse :: Bool
myFocusFollowsMouse = False

myClickJustFocuses :: Bool
myClickJustFocuses = False

-- sizes
--
gap = 10
bargap = 16
topbar = 6
border = 0

-- theme
--
yellow = "#c0a36e"
orange = "#FFA066"
red = "#c34043"
magenta = "#957fb8"
violet = "#938AA9"
blue = "#7e9cd8"
cyan = "#6a9589"
green = "#76946a"

bg1 = "#1f1f28"
bg2 = "#2d4f67"

base00 = "#1F1F28"
base01 = "#2A2A37"
base02 = "#223249"
base03 = "#727169"
base04 = "#C8C093"
base05 = "#DCD7BA"
base06 = "#938AA9"
base07 = "#363646"
base08 = "#C34043"
base09 = "#FFA066"
base0A = "#DCA561"
base0B = "#98BB6C"
base0C = "#7FB4CA"
base0D = "#7E9CD8"
base0E = "#957FB8"
base0F = "#D27E99"

active = blue
activeWarn = red
inactive = base02
focusColor = blue
unfocusColor = base02

myBorderWidth = border

myModMask = mod4Mask

myWorkspaces = [" dev ", " www ", " sys ", " doc ", " vbox ", " chat ", " mus ", " vid ", " gfx "]

myNormalBorderColor = "#000000"
myFocusedBorderColor = active

myFont :: String
myFont = "xft:mononoki Nerd Font:style=Regular:pixelsize=15:hinting=true"

topBarTheme =
    def
        { fontName = myFont
        , inactiveBorderColor = base03
        , inactiveColor = base03
        , inactiveTextColor = base03
        , activeBorderColor = active
        , activeColor = active
        , activeTextColor = active
        , urgentBorderColor = red
        , urgentTextColor = yellow
        , decoHeight = topbar
        }

myTabTheme =
    def
        { fontName = myFont
        , activeColor = active
        , inactiveColor = base02
        , activeBorderColor = active
        , inactiveBorderColor = base02
        , activeTextColor = base03
        , inactiveTextColor = base00
        }

myShowWNameTheme =
    def
        { swn_font = myFont
        , swn_fade = 0.5
        , swn_bgcolor = "#000000"
        , swn_color = "#FFFFFF"
        }

myNav2DConf =
    def
        { defaultTiledNavigation = centerNavigation
        , floatNavigation = centerNavigation
        , screenNavigation = lineNavigation
        , layoutNavigation =
            [ ("Full", centerNavigation)
            -- line/center same results   ,("Simple Tabs", lineNavigation)
            --                            ,("Simple Tabs", centerNavigation)
            ]
        , unmappedWindowRect =
            [ ("Full", singleWindowRect)
            -- works but breaks tab deco  ,("Simple Tabs", singleWindowRect)
            -- doesn't work but deco ok   ,("Simple Tabs", fullScreenRect)
            ]
        }

------------------------------------------------------------------------
-- Key bindings. Add, modify or remove key bindings here.

myKeys conf@(XConfig{XMonad.modMask = modm}) =
    M.fromList $
        -- launch terminal
        [ ((modm, xK_Return), spawn myTerminal)
        , -- launch firefox
          ((modm, xK_b), spawn myBrowser)
        , -- volume control
          ((0, xK_F2), spawn "pamixer -d 5")
        , ((0, xK_F3), spawn "pamixer -i 5")
        , ((0, xK_F4), spawn "pamixer -t")
        , ((0, xK_F7), spawn "playerctl play-pause -p spotify")
        , ((0, xK_F6), spawn "playerctl previous -p spotify")
        , ((0, xK_F8), spawn "playerctl next -p spotify")
        , -- take screenshot
          ((0, xK_Print), unGrab *> spawn "scrot -s")
        , -- launch rofi
          ((modm, xK_p), spawn myLauncher)
        , -- lock screen
          ((modm, xK_x), spawn "slock")
        , -- kill focused window
          ((modm .|. shiftMask, xK_c), kill)
        , -- Rotate through available layouts
          ((modm, xK_space), sendMessage NextLayout)
        , -- Rotate through sublayouts
          ((modm .|. controlMask, xK_space), toSubl NextLayout)
        , -- Toggle full screen

            ( (modm, xK_f)
            , sequence_
                [ (withFocused $ windows . W.sink)
                , (sendMessage $ XMonad.Layout.MultiToggle.Toggle FULL)
                ]
            )
        , -- Toggle Reflect
          ((modm, xK_y), sendMessage $ XMonad.Layout.MultiToggle.Toggle MIRROR)
        , -- Toggle Mirror
          ((modm .|. shiftMask, xK_y), sendMessage $ XMonad.Layout.MultiToggle.Toggle REFLECTX)
        , --  Reset the layouts on the current workspace to default
          ((modm .|. shiftMask, xK_space), setLayout $ XMonad.layoutHook conf)
        , -- Resize viewed windows to the correct size
          ((modm, xK_n), refresh)
        , -- Move focus to the next windog
          ((modm, xK_j), BW.focusDown)
        , -- Move focus to the previous window
          ((modm, xK_k), BW.focusUp)
        , -- Move focus to the master window
          ((modm, xK_m), BW.focusMaster)
        , -- Move focus to the unrgent window
          ((modm, xK_u), focusUrgent)
        , -- Swap the focused window and the master window
          ((modm .|. shiftMask, xK_m), windows W.swapMaster)
        , -- Swap the focused window with the next window
          ((modm .|. shiftMask, xK_j), windows W.swapDown)
        , -- Swap the focused window with the previous window
          ((modm .|. shiftMask, xK_k), windows W.swapUp)
        , -- Sublayout merge
          ((modm .|. controlMask, xK_j), sendMessage $ pullGroup D)
        , ((modm .|. controlMask, xK_k), sendMessage $ pullGroup U)
        , ((modm .|. controlMask, xK_h), sendMessage $ pullGroup L)
        , ((modm .|. controlMask, xK_l), sendMessage $ pullGroup R)
        , -- Un-merge from sublayout
          ((modm .|. controlMask, xK_u), withFocused (sendMessage . UnMerge))
        , -- Merge all into sublayout
          ((modm .|. controlMask, xK_m), withFocused (sendMessage . MergeAll))
        , -- Sublayout Focus
          ((modm .|. controlMask, xK_period), onGroup W.focusUp')
        , ((modm .|. controlMask, xK_comma), onGroup W.focusDown')
        , -- Shrink the master area
          ((modm, xK_h), sendMessage Shrink)
        , -- Expand the master area
          ((modm, xK_l), sendMessage Expand)
        , -- Push window back into tiling
          ((modm, xK_t), withFocused $ windows . W.sink)
        , -- Increment the number of windows in the master area
          ((modm, xK_comma), sendMessage (IncMasterN 1))
        , -- Deincrement the number of windows in the master area
          ((modm, xK_period), sendMessage (IncMasterN (-1)))
        , -- Quit xmonad
          ((modm .|. shiftMask, xK_q), io (exitWith ExitSuccess))
        , -- Restart xmonad
          ((modm, xK_q), spawn "xmonad --recompile; xmonad --restart")
        , -- Run xmessage with a summary of the default keybindings (useful for beginners)
          ((modm .|. shiftMask, xK_slash), spawn ("echo \"" ++ help ++ "\" | xmessage -file -"))
        , -- terminal scratchpad
          ((modm .|. shiftMask, xK_Return), namedScratchpadAction myScratchPads "terminal")
        ]
            ++
            --
            -- mod-[1..9], Switch to workspace N
            -- mod-shift-[1..9], Move client to workspace N
            --
            [ ((m .|. modm, k), windows $ f i)
            | (i, k) <- zip (XMonad.workspaces conf) [xK_1 .. xK_9]
            , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]
            ]
            ++
            --
            -- mod-, Switch to physical/Xinerama screens 1, 2, or 3
            -- mod-shift-{w,e,r}, Move client to screen 1, 2, or 3
            --
            [ ((m .|. modm, key), screenWorkspace sc >>= flip whenJust (windows . f))
            | (key, sc) <- zip [xK_w, xK_e, xK_r] [0 ..]
            , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]
            ]

------------------------------------------------------------------------
-- Mouse bindings: default actions bound to mouse events
--
myMouseBindings (XConfig{XMonad.modMask = modm}) =
    M.fromList $
        -- mod-button1, Set the window to floating mode and move by dragging
        [
            ( (modm, button1)
            , ( \w ->
                    focus w >> mouseMoveWindow w
                        >> windows W.shiftMaster
              )
            )
        , -- mod-button2, Raise the window to the top of the stack
          ((modm, button2), (\w -> focus w >> windows W.shiftMaster))
        , -- mod-button3, Set the window to floating mode and resize by dragging

            ( (modm, button3)
            , ( \w ->
                    focus w >> mouseResizeWindow w
                        >> windows W.shiftMaster
              )
            )
            -- you may also bind events to the mouse scroll wheel (button4 and button5)
        ]

------------------------------------------------------------------------
-- Layouts:

-- You can specify and transform your layouts by modifying these values.
-- If you change layout bindings be sure to use 'mod-shift-space' after
-- restarting (with 'mod-q') to reset your layout state to the new
-- defaults, as xmonad preserves your old layout settings by default.
--
-- The available layouts.  Note that each layout is separated by |||,
-- which denotes layout choice.
--
--
data FULLBAR = FULLBAR deriving (Read, Show, Eq, Typeable)
instance Transformer FULLBAR Window where
    transform FULLBAR x k = k barFull (\_ -> x)

barFull = avoidStruts $ Simplest

myLayout =
    showWorkspaceName $
        fullscreenFloat $
            fullScreenToggle $
                BW.boringWindows $
                    flex ||| tabs
  where
    fullBarToggle = mkToggle (single FULLBAR)
    fullScreenToggle = mkToggle (single FULL)
    mirrorToggle = mkToggle (single MIRROR)
    reflectToggle = mkToggle (single REFLECTX)
    showWorkspaceName = showWName' myShowWNameTheme

    named n = renamed [(XMonad.Layout.Renamed.Replace n)]

    addTopBar n = named "flex" $ IfMaxAlt 1 (n) (noFrillsDeco shrinkText topBarTheme $ n)

    mySpacing = spacingWithEdge gap
    myGaps = gaps [(U, bargap), (D, bargap)]

    tabs =
        named "Tabs" $
            addTabs shrinkText myTabTheme $
                Simplest

    mySubLayout = subLayout [] ((named "tab" $ Simplest) ||| (named "acc" $ Accordion))

    flex =
        addTopBar $
            addTabs shrinkText myTabTheme $
                myGaps $
                    mySpacing $
                        fullBarToggle $
                            reflectToggle $
                                mirrorToggle $ (tall ||| tcol)
      where
        tall =
            named "tall" $
                windowNavigation $
                    mySubLayout $
                        (named "tall" $ ResizableTall 1 (1 / 20) (2 / 3) [])

        tcol =
            named "tcol" $
                windowNavigation $
                    mySubLayout $
                        (named "tcol" $ ThreeColMid 1 (1 / 20) (1 / 2))

------------------------------------------------------------------------
-- Named Scatch Pads
--
myScratchPads :: [NamedScratchpad]
myScratchPads =
    [ NS "terminal" spawnTerm findTerm manageTerm
    ]
  where
    spawnTerm = myTerminal ++ " -t scratchpad"
    findTerm = title =? "scratchpad"
    manageTerm = customFloating $ W.RationalRect l t w h
      where
        h = 0.9
        w = 0.9
        t = 0.95 - h
        l = 0.95 - w

------------------------------------------------------------------------
-- Window rules:

-- Execute arbitrary actions and WindowSet manipulations when managing
-- a new window. You can use this to, for example, always float a
-- particular program, or have a client always appear on a particular
-- workspace.
--
-- To find the property name associated with a program, use
-- > xprop | grep WM_CLASS
-- and click on the client you're interested in.
--
-- To match on the WM_NAME, you can use 'title' in the same way that
-- 'className' and 'resource' are used below.
--
--

myManageHook =
    composeAll
        [ className =? "MPlayer" --> doFloat
        , className =? "Gimp" --> doFloat
        , appName =? "polybar" --> doIgnore
        , resource =? "desktop_window" --> doIgnore
        , resource =? "kdesktop" --> doIgnore
        , (className =? "firefox" <&&> resource =? "Dialog") --> doFloat
        ]
        <+> namedScratchpadManageHook myScratchPads
        <+> insertPosition End Newer

---------------------------------------------------------------------- Event handling

-- * EwmhDesktops users should change this to ewmhDesktopsEventHook

--
-- Defines a custom handler function for X Events. The function should
-- return (All True) if the default handler is to be run afterwards. To
-- combine event hooks use mappend or mconcat from Data.Monoid.
--
myEventHook = mySpotifyCompose <+> swallowEventHook (className =? "Alacritty") (return True)
  where
    mySpotifyCompose = dynamicPropertyChange "WM_NAME" (title =? "Spotify" --> doShift (myWorkspaces !! 6))

------------------------------------------------------------------------
-- Status bars and logging

-- Perform an arbitrary action on each internal state change or X event.
-- See the 'XMonad.Hooks.DynamicLog' extension for examples.
--
--
--

windowCount :: X (Maybe String)
windowCount = gets $ Just . show . length . W.integrate' . W.stack . W.workspace . W.current . windowset

myLogHook :: D.Client -> PP
myLogHook dbus =
    def
        { ppOutput = dbusOutput dbus
        , ppCurrent = wrap ("%{B" ++ active ++ "}") "%{B-}"
        , ppVisible = wrap ("%{B" ++ bg2 ++ "}") "%{B-}"
        , ppUrgent = wrap ("%{F" ++ red ++ "}") "%{F-}"
        , ppHidden = wrap "" ""
        , ppHiddenNoWindows = wrap "" ""
        , ppWsSep = ""
        , ppLayout = wrap "| " " "
        , ppSep = ""
        , ppExtras = myWindowCount ++ myTitle
        , ppOrder = \(ws : l : t : ex) -> [ws, l] ++ ex
        }
  where
    myWindowCount = [logConst " ", windowCount, logConst " "]
    myTitle = [wrapL " " " " $ fixedWidthL AlignLeft " " 10 $ shortenL 10 $ logTitle]

dbusOutput :: D.Client -> String -> IO ()
dbusOutput dbus str = do
    let signal =
            (D.signal objectPath interfaceName memberName)
                { D.signalBody = [D.toVariant $ UTF8.decodeString str]
                }
    D.emit dbus signal
  where
    objectPath = D.objectPath_ "/org/xmonad/Log"
    interfaceName = D.interfaceName_ "org.xmonad.Log"
    memberName = D.memberName_ "Update"

------------------------------------------------------------------------
-- Startup hook

-- Perform an arbitrary action each time xmonad starts or is restarted
-- with mod-q.  Used by, e.g., XMonad.Layout.PerWorkspace to initialize
-- per-workspace layout choices.
--
-- By default, do nothing.
myStartupHook = do
    spawn "ibus-daemon -d"

------------------------------------------------------------------------
-- Now run xmonad with all the defaults we set up.

-- Run xmonad with the settings you specify. No need to modify this.
--
main :: IO ()
main = do
    dbus <- D.connectSession
    -- Request access to the DBus name
    D.requestName
        dbus
        (D.busName_ "org.xmonad.Log")
        [D.nameAllowReplacement, D.nameReplaceExisting, D.nameDoNotQueue]

    xmonad $
        fullscreenSupport $
            docks
                . ewmhFullscreen
                . ewmh
                $ defaults
                    { logHook = dynamicLogWithPP . filterOutWsPP ["NSP"] $ (myLogHook dbus)
                    }

-- A structure containing your configuration settings, overriding
-- fields in the default config. Any you don't override, will
-- use the defaults defined in xmonad/XMonad/Config.hs
--
-- No need to modify this.
--
defaults =
    def
        { -- simple stuff
          terminal = myTerminal
        , focusFollowsMouse = myFocusFollowsMouse
        , clickJustFocuses = myClickJustFocuses
        , borderWidth = myBorderWidth
        , modMask = myModMask
        , workspaces = myWorkspaces
        , normalBorderColor = myNormalBorderColor
        , focusedBorderColor = myFocusedBorderColor
        , -- key bindings
          keys = myKeys
        , mouseBindings = myMouseBindings
        , -- hooks, layouts
          layoutHook = myLayout
        , manageHook = myManageHook
        , handleEventHook = myEventHook
        , startupHook = myStartupHook
        }

-- | Finally, a copy of the default bindings in simple textual tabular format.
help :: String
help =
    unlines
        [ "The default modifier key is 'alt'. Default keybindings:"
        , ""
        , "-- launching and killing programs"
        , "mod-Shift-Enter  Launch xterminal"
        , "mod-p            Launch dmenu"
        , "mod-Shift-p      Launch gmrun"
        , "mod-Shift-c      Close/kill the focused window"
        , "mod-Space        Rotate through the available layout algorithms"
        , "mod-Shift-Space  Reset the layouts on the current workSpace to default"
        , "mod-n            Resize/refresh viewed windows to the correct size"
        , ""
        , "-- move focus up or down the window stack"
        , "mod-Tab        Move focus to the next window"
        , "mod-Shift-Tab  Move focus to the previous window"
        , "mod-j          Move focus to the next window"
        , "mod-k          Move focus to the previous window"
        , "mod-m          Move focus to the master window"
        , ""
        , "-- modifying the window order"
        , "mod-Return   Swap the focused window and the master window"
        , "mod-Shift-j  Swap the focused window with the next window"
        , "mod-Shift-k  Swap the focused window with the previous window"
        , ""
        , "-- resizing the master/slave ratio"
        , "mod-h  Shrink the master area"
        , "mod-l  Expand the master area"
        , ""
        , "-- floating layer support"
        , "mod-t  Push window back into tiling; unfloat and re-tile it"
        , ""
        , "-- increase or decrease number of windows in the master area"
        , "mod-comma  (mod-,)   Increment the number of windows in the master area"
        , "mod-period (mod-.)   Deincrement the number of windows in the master area"
        , ""
        , "-- quit, or restart"
        , "mod-Shift-q  Quit xmonad"
        , "mod-q        Restart xmonad"
        , "mod-[1..9]   Switch to workSpace N"
        , ""
        , "-- Workspaces & screens"
        , "mod-Shift-[1..9]   Move client to workspace N"
        , "mod-{w,e,r}        Switch to physical/Xinerama screens 1, 2, or 3"
        , "mod-Shift-{w,e,r}  Move client to screen 1, 2, or 3"
        , ""
        , "-- Mouse bindings: default actions bound to mouse events"
        , "mod-button1  Set the window to floating mode and move by dragging"
        , "mod-button2  Raise the window to the top of the stack"
        , "mod-button3  Set the window to floating mode and resize by dragging"
        ]
