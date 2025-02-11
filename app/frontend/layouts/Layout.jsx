import React from 'react';
import { Link, usePage } from '@inertiajs/react';

const Layout = ({ children }) => {
    const { user } = usePage().props; // Accede a las props globales (como el usuario autenticado)

    return (
        <div className="min-h-screen flex flex-col">
            {/* Header */}
            <header className="bg-blue-500 text-white p-4">
                <nav className="flex justify-between">
                    <div>
                        <Link href="/" className="text-lg font-bold">Mi App</Link>
                    </div>
                    <div>
                        {user ? (
                            <span>Bienvenido, {user.name}</span>
                        ) : (
                            <Link href="/login" className="text-white">Iniciar sesión</Link>
                        )}
                    </div>
                </nav>
            </header>

            {/* Main content */}
            <main className="flex-grow p-4">
                {children}
            </main>

            {/* Footer */}
            <footer className="bg-gray-800 text-white text-center p-4">
                &copy; 2025 Mi App. Todos los derechos reservados.
            </footer>
        </div>
    );
};

export default Layout;
