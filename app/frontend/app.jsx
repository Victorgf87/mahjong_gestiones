import React from 'react';
import { createInertiaApp } from '@inertiajs/react';
import Layout from './layouts/Layout';

createInertiaApp({
    resolve: name => {
        const pages = import.meta.glob('./pages/**/*.jsx', { eager: true });
        const page = pages[`./pages/${name}.jsx`];

        // Asigna el layout por defecto si no está definido en la página
        page.default.layout = page.default.layout || ((page) => <Layout>{page}</Layout>);

        return page;
    },
    setup({ el, App, props }) {
        ReactDOM.render(<App {...props} />, el);
    },
});
