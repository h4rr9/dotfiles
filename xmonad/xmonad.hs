import XMonad

import XMonad.Util.Dzen
import XMonad.Util.SpawnOnce
import XMonad.Util.Ungrab

import XMonad.Layout.Fullscreen
import XMonad.Layout.Gaps
import XMonad.Layout.LimitWindows
import XMonad.Layout.NoBorders
import XMonad.Layout.Renamed
import XMonad.Layout.ResizableTile
import XMonad.Layout.ShowWName
import XMonad.Layout.Spacing
import XMonad.Layout.ThreeColumns
import XMonad.Layout.ToggleLayouts

import Data.Monoid
import Graphics.X11.ExtraTypes.XF86
import System.Exit

import XMonad.Hooks.DynamicLog
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.InsertPosition
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.WindowSwallowing

import qualified Codec.Binary.UTF8.String as UTF8
import qualified DBus as D
import qualified DBus.Client as D
import qualified Data.Map as M
import qualified XMonad.StackSet as W

myTerminal = "alacritty"

myFocusFollowsMouse :: Bool
myFocusFollowsMouse = False

myClickJustFocuses :: Bool
myClickJustFocuses = False

myBorderWidth = 4

myModMask = mod4Mask

myWorkspaces = [" dev ", " www ", " sys ", " doc ", " vbox ", " chat ", " mus ", " vid ", " gfx "]

myNormalBorderColor = "#727168"
myFocusedBorderColor = "#7fb4ca"

fg = "#ebdbb2"
bg = "#282828"
gray = "#a89984"
bg1 = "#3c3836"
bg2 = "#504945"
bg3 = "#665c54"
bg4 = "#7c6f64"

green = "#b8bb26"
darkgreen = "#98971a"
red = "#fb4934"
darkred = "#cc241d"
yellow = "#fabd2f"
blue = "#83a598"
purple = "#d3869b"
aqua = "#8ec07c"

------------------------------------------------------------------------
-- Key bindings. Add, modify or remove key bindings here.

myKeys conf@(XConfig{XMonad.modMask = modm}) =
    M.fromList $
        -- launch terminal
        [ ((modm .|. shiftMask, xK_Return), spawn $ XMonad.terminal conf)
        , -- launch firefox
          ((modm, xK_b), spawn "firefox")
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
          ((modm, xK_p), spawn "~/.local/bin/myrofi")
        , -- lock screen
          ((modm, xK_x), spawn "slock")
        , -- kill focused window
          ((modm .|. shiftMask, xK_c), kill)
        , -- Rotate through the available layout algorithms
          ((modm, xK_space), sendMessage NextLayout >> (curLayout >>= \d -> spawn $ "echo " ++ d ++ " | dzen2 -p 1 -w 40 -h 30 -x 940 -y 525"))
        , -- Toggle full screen
          ((modm, xK_f), sendMessage ToggleLayout)
        , --  Reset the layouts on the current workspace to default
          ((modm .|. shiftMask, xK_space), setLayout $ XMonad.layoutHook conf)
        , -- Resize viewed windows to the correct size
          ((modm, xK_n), refresh)
        , -- Move focus to the next window
          ((modm, xK_Tab), windows W.focusDown)
        , -- Move focus to the next window
          ((modm, xK_j), windows W.focusDown)
        , -- Move focus to the previous window
          ((modm, xK_k), windows W.focusUp)
        , -- Move focus to the master window
          ((modm, xK_m), windows W.focusMaster)
        , -- Swap the focused window and the master window
          ((modm, xK_Return), windows W.swapMaster)
        , -- Swap the focused window with the next window
          ((modm .|. shiftMask, xK_j), windows W.swapDown)
        , -- Swap the focused window with the previous window
          ((modm .|. shiftMask, xK_k), windows W.swapUp)
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
            -- mod-{w,e,r}, Switch to physical/Xinerama screens 1, 2, or 3
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

curLayout :: X String
curLayout = gets windowset >>= return . description . W.layout . W.workspace . W.current

tall =
    renamed [Replace "tall"] $
        spacingWithEdge 10 $
            gaps [(U, 15), (D, 15)] $
                smartBorders $
                    limitWindows 12 $
                        ResizableTall 1 (3 / 100) (1 / 2) []

long =
    renamed [Replace "long"] $
        spacingWithEdge 10 $
            gaps [(U, 15), (D, 15)] $
                smartBorders $
                    limitWindows 12 $
                        Mirror $
                            ResizableTall 1 (3 / 100) (1 / 2) []

threeCol =
    renamed [Replace "tcol"] $
        spacingWithEdge 10 $
            gaps [(U, 15), (D, 15)] $
                smartBorders $
                    limitWindows 5 $
                        ThreeColMid 1 (3 / 100) (1 / 2)

threeRow =
    renamed [Replace "trow"] $
        spacingWithEdge 10 $
            gaps [(U, 15), (D, 15)] $
                smartBorders $
                    limitWindows 5 $
                        Mirror $
                            ThreeColMid 1 (3 / 100) (1 / 2)

full =
    renamed [Replace "full"] $
        smartBorders $
            limitWindows 12 $
                noBorders $ Full

myLayout = toggleLayouts full $ showWName $ tall ||| threeCol ||| long ||| threeRow

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
        ]
        <+> insertPosition End Newer

---------------------------------------------------------------------- Event handling

-- * EwmhDesktops users should change this to ewmhDesktopsEventHook

--
-- Defines a custom handler function for X Events. The function should
-- return (All True) if the default handler is to be run afterwards. To
-- combine event hooks use mappend or mconcat from Data.Monoid.
--
myEventHook = swallowEventHook (className =? "Alacritty" <||> className =? "Termite") (return True)

------------------------------------------------------------------------
-- Status bars and logging

-- Perform an arbitrary action on each internal state change or X event.
-- See the 'XMonad.Hooks.DynamicLog' extension for examples.
--
myLogHook :: D.Client -> PP
myLogHook dbus =
    def
        { ppOutput = dbusOutput dbus
        , ppCurrent = wrap ("%{B" ++ bg2 ++ "}") "%{B-}"
        , ppVisible = wrap ("%{B" ++ bg1 ++ "}") "%{B-}"
        , ppUrgent = wrap ("%{F" ++ red ++ "}") "%{F-}"
        , ppHiddenNoWindows = wrap "" ""
        , ppWsSep = ""
        , -- , ppSep = " | "
          ppOrder = \(ws : l : t : ex) -> [ws]
        }

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
                    { logHook = dynamicLogWithPP (myLogHook dbus)
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
