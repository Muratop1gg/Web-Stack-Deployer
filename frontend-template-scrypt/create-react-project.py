#!/usr/bin/env python3
"""
React Project Setup Script
Creates a new React project with Vite, TypeScript, Tailwind CSS, and optional Telegram WebApp support
"""

import os
import sys
import subprocess
import json
import shutil
from pathlib import Path
import argparse

# Colors for terminal output
class Colors:
    GREEN = '\033[92m'
    YELLOW = '\033[93m'
    RED = '\033[91m'
    BLUE = '\033[94m'
    PURPLE = '\033[95m'
    CYAN = '\033[96m'
    RESET = '\033[0m'

def print_info(message):
    print(f"{Colors.BLUE}ℹ️  {message}{Colors.RESET}")

def print_success(message):
    print(f"{Colors.GREEN}✅ {message}{Colors.RESET}")

def print_warning(message):
    print(f"{Colors.YELLOW}⚠️  {message}{Colors.RESET}")

def print_error(message):
    print(f"{Colors.RED}❌ {message}{Colors.RESET}")

def run_command(command, cwd=None):
    """Run a shell command and return success status"""
    try:
        print_info(f"Executing: {command}")
        result = subprocess.run(
            command, 
            shell=True, 
            cwd=cwd, 
            capture_output=True, 
            text=True,
            timeout=120  # 2 minute timeout
        )
        
        if result.returncode != 0:
            print_error(f"Command failed: {command}")
            if result.stdout:
                print_error(f"Stdout: {result.stdout}")
            if result.stderr:
                print_error(f"Stderr: {result.stderr}")
            return False
        
        if result.stdout:
            print_info(f"Output: {result.stdout.strip()}")
            
        return True
        
    except subprocess.TimeoutExpired:
        print_error(f"Command timed out: {command}")
        return False
    except Exception as e:
        print_error(f"Error running command: {command}")
        print_error(f"Exception: {str(e)}")
        return False

def check_node_installed():
    """Check if Node.js and npm are installed"""
    try:
        # Check Node.js
        node_result = subprocess.run(["node", "--version"], capture_output=True, text=True, shell=True)
        if node_result.returncode != 0:
            print_error(f"Node.js not found: {node_result.stderr.strip()}")
            return False
        
        # Check npm
        npm_result = subprocess.run(["npm", "--version"], capture_output=True, text=True, shell=True)
        if npm_result.returncode != 0:
            print_error(f"npm not found: {npm_result.stderr.strip()}")
            return False
        
        print_success(f"Node.js {node_result.stdout.strip()}, npm {npm_result.stdout.strip()} detected")
        return True
        
    except FileNotFoundError:
        print_error("Node.js or npm not found in PATH")
        return False
    except Exception as e:
        print_error(f"Error checking Node.js installation: {str(e)}")
        return False

def create_project_structure(project_path):
    """Create the project folder structure"""
    folders = [
        "src/components",
        "src/lib",
        "src/pages", 
        "src/types",
        "src/utils"
    ]
    
    for folder in folders:
        folder_path = project_path / folder
        folder_path.mkdir(parents=True, exist_ok=True)
    
    print_success("Project structure created")

def create_file(file_path, content):
    """Create a file with the given content"""
    with open(file_path, 'w', encoding='utf-8') as f:
        f.write(content)

def setup_vite_project(project_path):
    """Create Vite React TypeScript project"""
    print_info("Creating Vite React TypeScript project...")
    
    # Use echo to automatically answer "n" to rolldown question
    command = 'echo "n" | npm create vite@latest . -- --template react-ts'
    
    if not run_command(command, cwd=project_path):
        print_error("Failed to create Vite project")
        return False
    
    # Verify that project was created successfully
    if not (project_path / "package.json").exists():
        print_error("Project creation failed - package.json not found")
        return False
    
    print_success("Vite project created successfully")
    return True

def install_dependencies(project_path, project_type):
    """Install project dependencies with React Router v7"""
    print_info("Installing base dependencies...")
    
    if not run_command("npm install", cwd=project_path):
        return False
    
    print_info("Installing additional dependencies...")
    
    # Основные изменения для React Router v7
    dependencies = [
        "react-router@latest",  # Единый пакет React Router v7
        "axios", 
        "jwt-decode",
        "dayjs",
        "clsx",
        "tailwind-merge",
        "tailwindcss",
        "@tailwindcss/vite",
        "tw-animate-css"
    ]
    
    if project_type == "telegram":
        dependencies.append("@telegram-apps/sdk")
    
    deps_command = f"npm install {' '.join(dependencies)}"
    if not run_command(deps_command, cwd=project_path):
        return False
    
    print_info("Installing dev dependencies...")
    
    dev_dependencies = [
        "@types/react",
        "@types/react-dom", 
        "@types/jwt-decode",
        "typescript"
        # @types/react-router-dom больше не нужен
    ]
    
    dev_deps_command = f"npm install --save-dev {' '.join(dev_dependencies)}"
    if not run_command(dev_deps_command, cwd=project_path):
        return False
    
    print_success("Dependencies installed with React Router v7")
    return True
def setup_tailwind(project_path):
    """Setup Tailwind CSS v4 - no initialization needed"""
    print_info("Setting up Tailwind CSS v4...")
    
    # No need to run tailwindcss init -p anymore
    # Configuration is handled via Vite plugin
    
    print_success("Tailwind CSS v4 setup completed")
    return True

def update_config_files(project_path):
    """Update configuration files for Tailwind CSS v4"""
    print_info("Updating configuration files...")
    
    # Update vite.config.ts for Tailwind v4
    vite_config = '''import { defineConfig } from 'vite'
import react from '@vitejs/plugin-react'
import path from "path"
import tailwindcss from '@tailwindcss/vite'

// https://vitejs.dev/config/
export default defineConfig({
  plugins: [
    react(),
    tailwindcss(),
  ],
  resolve: {
    alias: {
      "@": path.resolve(__dirname, "./src"),
    },
  },
})
'''
    create_file(project_path / "vite.config.ts", vite_config)
    
    print_success("Configuration files updated for Tailwind v4")

def create_css_file(project_path):
    """Create the CSS file with Tailwind v4 configuration"""
    print_info("Creating CSS file with Tailwind v4 configuration...")
    
    css_content = '''@import "tailwindcss";
@import "tw-animate-css";

/* Custom CSS variables and theme configuration */
@custom-variant dark (&:is(.dark *));

@theme inline {
    --radius-sm: calc(var(--radius) - 4px);
    --radius-md: calc(var(--radius) - 2px);
    --radius-lg: var(--radius);
    --radius-xl: calc(var(--radius) + 4px);
    --color-background: var(--background);
    --color-foreground: var(--foreground);
    --color-card: var(--card);
    --color-card-foreground: var(--card-foreground);
    --color-popover: var(--popover);
    --color-popover-foreground: var(--popover-foreground);
    --color-primary: var(--primary);
    --color-primary-foreground: var(--primary-foreground);
    --color-secondary: var(--secondary);
    --color-secondary-foreground: var(--secondary-foreground);
    --color-muted: var(--muted);
    --color-muted-foreground: var(--muted-foreground);
    --color-accent: var(--accent);
    --color-accent-foreground: var(--accent-foreground);
    --color-destructive: var(--destructive);
    --color-border: var(--border);
    --color-input: var(--input);
    --color-ring: var(--ring);
    --color-chart-1: var(--chart-1);
    --color-chart-2: var(--chart-2);
    --color-chart-3: var(--chart-3);
    --color-chart-4: var(--chart-4);
    --color-chart-5: var(--chart-5);
    --color-sidebar: var(--sidebar);
    --color-sidebar-foreground: var(--sidebar-foreground);
    --color-sidebar-primary: var(--sidebar-primary);
    --color-sidebar-primary-foreground: var(--sidebar-primary-foreground);
    --color-sidebar-accent: var(--sidebar-accent);
    --color-sidebar-accent-foreground: var(--sidebar-accent-foreground);
    --color-sidebar-border: var(--sidebar-border);
    --color-sidebar-ring: var(--sidebar-ring);
}

:root {
    --radius: 0.625rem;
    --background: oklch(1 0 0);
    --foreground: oklch(17.764% 0.00002 271.152);
    --card: oklch(1 0 0);
    --card-foreground: oklch(0.141 0.005 285.823);
    --popover: oklch(1 0 0);
    --popover-foreground: oklch(0.141 0.005 285.823);
    --primary: oklch(0.21 0.006 285.885);
    --primary-foreground: oklch(0.985 0 0);
    --secondary: oklch(0.967 0.001 286.375);
    --secondary-foreground: oklch(0.21 0.006 285.885);
    --muted: oklch(0.967 0.001 286.375);
    --muted-foreground: oklch(0.552 0.016 285.938);
    --accent: oklch(0.967 0.001 286.375);
    --accent-foreground: oklch(0.21 0.006 285.885);
    --destructive: oklch(0.577 0.245 27.325);
    --border: oklch(0.92 0.004 286.32);
    --input: oklch(0.92 0.004 286.32);
    --ring: oklch(0.705 0.015 286.067);
    --chart-1: oklch(0.646 0.222 41.116);
    --chart-2: oklch(0.6 0.118 184.704);
    --chart-3: oklch(0.398 0.07 227.392);
    --chart-4: oklch(0.828 0.189 84.429);
    --chart-5: oklch(0.769 0.188 70.08);
    --sidebar: oklch(0.985 0 0);
    --sidebar-foreground: oklch(0.141 0.005 285.823);
    --sidebar-primary: oklch(0.21 0.006 285.885);
    --sidebar-primary-foreground: oklch(0.985 0 0);
    --sidebar-accent: oklch(0.967 0.001 286.375);
    --sidebar-accent-foreground: oklch(0.21 0.006 285.885);
    --sidebar-border: oklch(0.92 0.004 286.32);
    --sidebar-ring: oklch(0.705 0.015 286.067);
}

.dark {
    --background: oklch(0.141 0.005 285.823);
    --foreground: oklch(0.985 0 0);
    --card: oklch(0.21 0.006 285.885);
    --card-foreground: oklch(0.985 0 0);
    --popover: oklch(0.21 0.006 285.885);
    --popover-foreground: oklch(0.985 0 0);
    --primary: oklch(0.92 0.004 286.32);
    --primary-foreground: oklch(0.21 0.006 285.885);
    --secondary: oklch(0.274 0.006 286.033);
    --secondary-foreground: oklch(0.985 0 0);
    --muted: oklch(0.274 0.006 286.033);
    --muted-foreground: oklch(0.705 0.015 286.067);
    --accent: oklch(0.274 0.006 286.033);
    --accent-foreground: oklch(0.985 0 0);
    --destructive: oklch(0.704 0.191 22.216);
    --border: oklch(1 0 0 / 10%);
    --input: oklch(1 0 0 / 15%);
    --ring: oklch(0.552 0.016 285.938);
    --chart-1: oklch(0.488 0.243 264.376);
    --chart-2: oklch(0.696 0.17 162.48);
    --chart-3: oklch(0.769 0.188 70.08);
    --chart-4: oklch(0.627 0.265 303.9);
    --chart-5: oklch(0.645 0.246 16.439);
    --sidebar: oklch(0.21 0.006 285.885);
    --sidebar-foreground: oklch(0.985 0 0);
    --sidebar-primary: oklch(0.488 0.243 264.376);
    --sidebar-primary-foreground: oklch(0.985 0 0);
    --sidebar-accent: oklch(0.274 0.006 286.033);
    --sidebar-accent-foreground: oklch(0.985 0 0);
    --sidebar-border: oklch(1 0 0 / 10%);
    --sidebar-ring: oklch(0.552 0.016 285.938);
}

@layer base {
    * {
        @apply border-border outline-ring/50;
    }

    body {
        @apply bg-background text-foreground;
    }
}
'''
    create_file(project_path / "src" / "index.css", css_content)
    print_success("CSS file created with Tailwind v4 configuration")

def create_type_definitions(project_path):
    """Create TypeScript type definitions for React Router v7"""
    types_content = '''export interface AuthState {
  isAuthenticated: boolean;
  isNewUser: boolean;
  hasError: boolean;
}

export interface ApiResponse<T = any> {
  data?: T;
  error?: string;
}

export interface User {
  id: string;
  username: string;
  email?: string;
}

export interface Tokens {
  access: string;
  refresh: string;
}

// React Router v7 error types
export interface RouteError {
  status?: number;
  statusText?: string;
  message?: string;
  data?: string;
  internal?: boolean;
  stack?: string;
}
'''
    create_file(project_path / "src" / "types" / "types.ts", types_content)
def create_utils(project_path):
    """Create utility files"""
    print_info("Creating utility files...")
    
    # cn utility
    utils_content = '''import { clsx, type ClassValue } from "clsx"
import { twMerge } from "tailwind-merge"

export function cn(...inputs: ClassValue[]) {
  return twMerge(clsx(inputs))
}
'''
    create_file(project_path / "src" / "lib" / "utils.ts", utils_content)
    
    # useAPI utility
    use_api_content = '''import axios from "axios";
import { jwtDecode } from "jwt-decode";
import dayjs from "dayjs";

const baseURL = "https://api.food-mind.com/api";

const useAxios = () => {
    const authTokens = JSON.parse(localStorage.getItem("tokens") ?? "{}")

    const axiosInstance = axios.create({
        baseURL,
        headers: { Authorization: `Bearer ${authTokens?.access}` }
    });

    axiosInstance.interceptors.request.use(async req => {
        try {
            if (req.data instanceof FormData) {
                delete req.headers["Content-Type"];
            }

            const user = jwtDecode(authTokens.access);
            const isExpired = user.exp ? dayjs.unix(user.exp).diff(dayjs()) < 1 : true;

            if (!isExpired) return req;

            const response = await axios.post(`${baseURL}/token/refresh/`, {
                refresh: authTokens.refresh
            });
            localStorage.setItem("authTokens", JSON.stringify(response.data));

            req.headers.Authorization = `Bearer ${response.data.access}`;
            return req;
        } catch (error) {
            console.error("Interceptor error:", error);
            return Promise.reject(error);
        }
    });

    return axiosInstance;
};

export default useAxios;
'''
    create_file(project_path / "src" / "utils" / "useApi.ts", use_api_content)
    
    # API functions
    api_content = '''import axios from "axios";
import useAxios from "./useApi";
import type * as Types from "@/types/types"

export default function useAPI() {
    const use_axios = useAxios()

    const retryRequest = async (requestFunc: () => Promise<any>, retries: number = 1) => {
        for (let i = 0; i < retries; i++) {
            try {
                const response = await requestFunc();
                return response;
            } catch (error) {
                if (axios.isAxiosError(error)) {
                    if (error.response?.status === 403) {
                        throw 403;
                    }
                    if (error.response?.status !== 404 || i === retries - 1) {
                        throw error;
                    }
                } else {
                    throw error;
                }
            }
            await new Promise(resolve => setTimeout(resolve, 5000));
        }
    };

    return {
        // Add your API functions here
        // Example:
        // getUser: () => retryRequest(() => use_axios.get("/user")),
    };
}
'''
    create_file(project_path / "src" / "utils" / "api.ts", api_content)

def create_theme_provider(project_path):
    """Create theme provider component"""
    theme_provider_content = '''import { createContext, useContext, useEffect, useState } from "react"

type Theme = "dark" | "light" | "system"

type ThemeProviderProps = {
    children: React.ReactNode
    defaultTheme?: Theme
    storageKey?: string
}

type ThemeProviderState = {
    theme: Theme
    setTheme: (theme: Theme) => void
}

const initialState: ThemeProviderState = {
    theme: "system",
    setTheme: () => null,
}

const ThemeProviderContext = createContext<ThemeProviderState>(initialState)

export function ThemeProvider({
    children,
    defaultTheme = "system",
    storageKey = "vite-ui-theme",
    ...props
}: ThemeProviderProps) {
    const [theme, setTheme] = useState<Theme>(
        () => (localStorage.getItem(storageKey) as Theme) || defaultTheme
    )

    useEffect(() => {
        const root = window.document.documentElement

        root.classList.remove("light", "dark")

        if (theme === "system") {
            const systemTheme = window.matchMedia("(prefers-color-scheme: dark)")
                .matches
                ? "dark"
                : "light"

            root.classList.add(systemTheme)
            return
        }

        root.classList.add(theme)
    }, [theme])

    const value = {
        theme,
        setTheme: (theme: Theme) => {
            localStorage.setItem(storageKey, theme)
            setTheme(theme)
        },
    }

    return (
        <ThemeProviderContext.Provider {...props} value={value}>
            {children}
        </ThemeProviderContext.Provider>
    )
}

export const useTheme = () => {
    const context = useContext(ThemeProviderContext)

    if (context === undefined)
        throw new Error("useTheme must be used within a ThemeProvider")

    return context
}
'''
    create_file(project_path / "src" / "components" / "theme-provider.tsx", theme_provider_content)

def create_pages(project_path):
    """Create page components for React Router v7"""
    print_info("Creating page components...")
    
    # ErrorPage для React Router v7
    error_page_content = '''import { Link } from "react-router";

export default function ErrorPage() {

  return (
    <div className="min-h-screen bg-background flex items-center justify-center p-4">
      <div className="text-center max-w-md">
        <div className="text-6xl mb-4">😵</div>
        <h1 className="text-4xl font-bold mb-4 text-destructive">
          {'Oops!'}
        </h1>

        <p className="text-lg mb-2 text-foreground">
          {'Sorry, an unexpected error has occurred.'}
        </p>

        <p className="text-muted-foreground mb-6">
          {'Unknown error'}
        </p>

        <div className="space-y-3">
          <Link
            to="/"
            className="inline-flex items-center justify-center px-4 py-2 bg-primary text-primary-foreground rounded-md hover:bg-primary/90 transition-colors"
          >
            Go Home
          </Link>

          <button
            onClick={() => window.location.reload()}
            className="block w-full px-4 py-2 bg-secondary text-secondary-foreground rounded-md hover:bg-secondary/80 transition-colors"
          >
            Reload Page
          </button>
        </div>


      </div>
    </div>
  );
}


'''
    create_file(project_path / "src" / "pages" / "ErrorPage.tsx", error_page_content)
    
    # MainPage с навигацией для демонстрации
    main_page_content = '''import { Link } from "react-router";

export default function MainPage() {
  return (
    <div className="min-h-screen bg-background">
      <div className="container mx-auto px-4 py-8">
        <h1 className="text-3xl font-bold mb-6">Main Page</h1>
        <p className="text-lg mb-6">Welcome to the main application with React Router v7!</p>

        <div className="space-y-4">
          <div className="p-4 border rounded-lg">
            <h2 className="text-xl font-semibold mb-2">Navigation Demo</h2>
            <div className="space-x-2">
              <Link
                to="/about"
                className="px-4 py-2 bg-primary text-primary-foreground rounded hover:bg-primary/90 transition-colors"
              >
                Go to About (404)
              </Link>
              <Link
                to="/broken"
                className="px-4 py-2 bg-destructive text-destructive-foreground rounded hover:bg-destructive/90 transition-colors"
              >
                Broken Link
              </Link>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
}

'''
    create_file(project_path / "src" / "pages" / "MainPage.tsx", main_page_content)

def remove_useless_files(project_path):
    """Remove unnecessary files from the Vite template"""
    print_info("Removing unnecessary files...")
    
    files_to_remove = [
        "src/App.css",
        "src/App.tsx",    # Мы создадим свой App.tsx
        "public/vite.svg",
        "src/assets/react.svg"
    ]
    
    removed_count = 0
    for file_path in files_to_remove:
        full_path = project_path / file_path
        if full_path.exists():
            try:
                full_path.unlink()
                print_info(f"Removed: {file_path}")
                removed_count += 1
            except Exception as e:
                print_warning(f"Could not remove {file_path}: {str(e)}")
    
    # Также удаляем папку assets если она пустая
    assets_dir = project_path / "src" / "assets"
    if assets_dir.exists() and not any(assets_dir.iterdir()):
        try:
            assets_dir.rmdir()
            print_info("Removed empty assets directory")
        except Exception as e:
            print_warning(f"Could not remove assets directory: {str(e)}")
    
    print_success(f"Removed {removed_count} unnecessary files")
    return True
    
def create_app_component(project_path, project_type):
    """Create App.tsx based on project type with React Router v7"""
    print_info("Creating App component for React Router v7...")
    
    if project_type == "telegram":
        app_content = '''import { ThemeProvider } from "./components/theme-provider"

import {
  createBrowserRouter,
  RouterProvider,
} from "react-router";


import ErrorPage from "./pages/ErrorPage";
import MainPage from "./pages/MainPage";



import { init, miniApp } from '@telegram-apps/sdk';


import { retrieveRawLaunchParams, retrieveLaunchParams } from '@telegram-apps/sdk';
import axios from 'axios';


import { useEffect, useState } from "react";


const mainRouter = createBrowserRouter([
  {
    path: "/",
    element: <MainPage />,
    errorElement: <ErrorPage />
  },

]);


const errorRouter = createBrowserRouter([
  {
    path: "*",
    element: <ErrorPage />
  }
]);

function App() {
  const [authState, setAuthState] = useState<{
    hasError: boolean;
  }>({
    hasError: false
  });
  const [isLoading, setIsLoading] = useState(true);

  useEffect(() => {
    initializeTelegramSDK();
  }, []);


  const initializeTelegramSDK = async () => {
    try {
      await init();

      if (miniApp.ready.isAvailable()) {
        await miniApp.ready();

      } else {
        console.warn('MiniApp not available');
        setAuthState({
          hasError: true
        });
      }
    } catch (error) {
      console.error('Ошибка инициализации:', error);
      setAuthState({
        hasError: true
      });
    } finally {
      setIsLoading(false);
    }
  };

  if (isLoading) {
    return (
      <ThemeProvider defaultTheme="system" storageKey="vite-ui-theme">
        <div className="relative bg-[#F3F3F3] dark:bg-[#111] w-screen h-screen flex items-center justify-center">
        </div>
      </ThemeProvider>
    );
  }

  // Определяем какой роутер использовать
  const getRouter = () => {
    if (authState.hasError) {
      return errorRouter;
    }

    return mainRouter;
  };

  return (
    <ThemeProvider defaultTheme="system" storageKey="vite-ui-theme">
      <RouterProvider router={getRouter()} />
    </ThemeProvider>
  );
}

export default App;
'''
    else:
        app_content = '''import { ThemeProvider } from "./components/theme-provider"

import {
  createBrowserRouter,
  RouterProvider,
} from "react-router";

import ErrorPage from "./pages/ErrorPage";
import MainPage from "./pages/MainPage";



const mainRouter = createBrowserRouter([
  {
    path: "/",
    element: <MainPage />,
    errorElement: <ErrorPage />
  },

]);


function App() {
  // Определяем какой роутер использовать
  const getRouter = () => {

    return mainRouter;
  };

  return (
    <ThemeProvider defaultTheme="system" storageKey="vite-ui-theme">
      <RouterProvider router={getRouter()} />
    </ThemeProvider>
  );
}

export default App;
'''
    
    create_file(project_path / "src" / "App.tsx", app_content)

def create_docker_config(project_path):
    """Create Docker configuration files"""
    print_info("Creating Docker configuration...")
    
    # Dockerfile
    dockerfile_content = '''FROM node:18-alpine AS builder

WORKDIR /app

COPY package*.json ./
RUN npm ci

COPY . .
RUN npm run build

FROM nginx:alpine

COPY --from=builder /app/dist /usr/share/nginx/html
COPY nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
'''
    create_file(project_path / "Dockerfile", dockerfile_content)
    
    # nginx.conf
    nginx_content = '''server {
    listen 80;
    server_name localhost;
    root /usr/share/nginx/html;
    index index.html;

    # Serve static files
    location / {
        try_files $uri $uri/ /index.html;
        add_header Cache-Control "no-cache, no-store, must-revalidate";
    }

    # Cache static assets
    location ~* \\.(js|css|png|jpg|jpeg|gif|ico|svg|woff2)$ {
        expires 1y;
        add_header Cache-Control "public, immutable";
    }

    # API proxy (если нужно)
    # location /api/ {
    #     proxy_pass http://backend:3000;
    #     proxy_set_header Host $host;
    #     proxy_set_header X-Real-IP $remote_addr;
    # }
}
'''
    create_file(project_path / "nginx.conf", nginx_content)
    
    # .dockerignore
    dockerignore_content = '''**/.git
**/.env
**/node_modules
**/docs
**/build
**/coverage
**/Dockerfile
**/docker-compose*
**/.vscode
**/npm-debug.log
'''
    create_file(project_path / ".dockerignore", dockerignore_content)

def update_package_json(project_path):
    """Update package.json scripts"""
    print_info("Updating package.json scripts...")
    
    package_json_path = project_path / "package.json"
    with open(package_json_path, 'r') as f:
        package_json = json.load(f)
    
    package_json["scripts"]["build"] = "tsc && vite build"
    package_json["scripts"]["preview"] = "vite preview --port 4173"
    
    with open(package_json_path, 'w') as f:
        json.dump(package_json, f, indent=2)

def main():
    parser = argparse.ArgumentParser(description="Create a new React project with Vite, TypeScript, and Tailwind CSS")
    parser.add_argument("project_name", help="Name of the project")
    parser.add_argument("project_type", choices=["telegram", "web"], help="Type of project: telegram or web")
    
    args = parser.parse_args()
    
    project_name = args.project_name
    project_type = args.project_type
    
    print_info(f"Creating project: {project_name} ({project_type})")
    
    # Check if Node.js is installed
    if not check_node_installed():
        print_error("Node.js is not installed. Please install Node.js first.")
        sys.exit(1)
    
    project_path = Path.cwd() / project_name
    
    # Check if project directory already exists
    if project_path.exists():
        print_error(f"Directory {project_name} already exists")
        sys.exit(1)
    
    try:
        # Create project directory
        project_path.mkdir()
        print_success("Project directory created")
        
        # Setup project
        if not setup_vite_project(project_path):
            sys.exit(1)
        
        if not install_dependencies(project_path, project_type):
            sys.exit(1)
        
        if not setup_tailwind(project_path):
            sys.exit(1)
        
        create_project_structure(project_path)
        update_config_files(project_path)
        create_css_file(project_path)
        create_type_definitions(project_path)
        create_utils(project_path)
        create_theme_provider(project_path)
        create_pages(project_path)
        remove_useless_files(project_path)
        create_app_component(project_path, project_type)
        create_docker_config(project_path)
        update_package_json(project_path)
        
        print_success("Project setup completed!")
        print("")
        print(f"{Colors.GREEN}🎉 Project {project_name} ({project_type}) created successfully!{Colors.RESET}")
        print("")
        print(f"{Colors.YELLOW}Next steps:{Colors.RESET}")
        print(f"1. cd {project_name}")
        print("2. npm run dev")
        print("")
        print(f"{Colors.BLUE}Available scripts:{Colors.RESET}")
        print("  npm run dev      - Start development server")
        print("  npm run build    - Build for production")
        print("  npm run preview  - Preview production build")
        print("")
        print(f"{Colors.GREEN}Happy coding! 🚀{Colors.RESET}")
        
    except Exception as e:
        print_error(f"An error occurred: {str(e)}")
        # Clean up on error
        if project_path.exists():
            shutil.rmtree(project_path)
        sys.exit(1)

if __name__ == "__main__":
    main()