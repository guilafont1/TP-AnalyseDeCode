package com.simplecity.amp_library.utils;

import android.appwidget.AppWidgetManager;
import android.content.Intent;
import android.media.AudioManager;

/**
 * Vérifications d'actions pour les composants exportés déclarés dans le manifeste.
 */
public final class IntentReceiverSafety {

    private IntentReceiverSafety() {
    }

    public static boolean isAllowedAppWidgetIntent(Intent intent) {
        if (intent == null) {
            return false;
        }
        String action = intent.getAction();
        if (action == null) {
            return false;
        }
        return AppWidgetManager.ACTION_APPWIDGET_UPDATE.equals(action)
                || AppWidgetManager.ACTION_APPWIDGET_DELETED.equals(action)
                || AppWidgetManager.ACTION_APPWIDGET_ENABLED.equals(action)
                || AppWidgetManager.ACTION_APPWIDGET_DISABLED.equals(action)
                || AppWidgetManager.ACTION_APPWIDGET_OPTIONS_CHANGED.equals(action);
    }

    public static boolean isAllowedMediaButtonIntent(Intent intent) {
        if (intent == null) {
            return false;
        }
        String action = intent.getAction();
        if (action == null) {
            return false;
        }
        return Intent.ACTION_MEDIA_BUTTON.equals(action)
                || AudioManager.ACTION_AUDIO_BECOMING_NOISY.equals(action)
                || Intent.ACTION_HEADSET_PLUG.equals(action);
    }
}
