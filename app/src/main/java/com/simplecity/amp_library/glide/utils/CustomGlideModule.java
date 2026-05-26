package com.simplecity.amp_library.glide.utils;

import android.content.Context;
import com.bumptech.glide.Glide;
import com.bumptech.glide.GlideBuilder;
import com.bumptech.glide.module.GlideModule;
import com.simplecity.amp_library.glide.loader.ArtworkModelLoader;
import com.simplecity.amp_library.model.ArtworkProvider;
import java.io.InputStream;

public class CustomGlideModule implements GlideModule {

    public CustomGlideModule() {
        // Constructeur requis par Glide ; aucune initialisation supplémentaire.
    }

    @Override
    public void applyOptions(Context context, GlideBuilder builder) {
        // Options Glide par défaut ; personnalisation non nécessaire pour ce module.
    }

    @Override
    public void registerComponents(Context context, Glide glide) {
        glide.register(ArtworkProvider.class, InputStream.class, new ArtworkModelLoader.Factory());
    }
}