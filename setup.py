"""
UnQPerp - AI CodeBase Bridge
Setup script for Python package installation

Created by: Sandeep Gaddam
Repository: UnQPerp
"""

from setuptools import setup, find_packages
import os

# Read the contents of README file
this_directory = os.path.abspath(os.path.dirname(__file__))
with open(os.path.join(this_directory, 'README.md'), encoding='utf-8') as f:
    long_description = f.read()

setup(
    name="unqperp",
    version="1.0.0",
    author="Sandeep Gaddam",
    author_email="devunq@gmail.com",
    description="AI CodeBase Bridge - Enable AI assistants to access and manage your local codebase",
    long_description=long_description,
    long_description_content_type="text/markdown",
    url="https://github.com/UnQOfficial/UnQPerp",
    packages=find_packages(),
    classifiers=[
        "Development Status :: 5 - Production/Stable",
        "Intended Audience :: Developers",
        "License :: OSI Approved :: MIT License",
        "Operating System :: OS Independent",
        "Programming Language :: Python :: 3",
        "Programming Language :: Python :: 3.7",
        "Programming Language :: Python :: 3.8",
        "Programming Language :: Python :: 3.9",
        "Programming Language :: Python :: 3.10",
        "Programming Language :: Python :: 3.11",
        "Topic :: Software Development :: Libraries :: Python Modules",
        "Topic :: Software Development :: Version Control :: Git",
        "Topic :: Internet :: WWW/HTTP :: HTTP Servers",
        "Topic :: Scientific/Engineering :: Artificial Intelligence",
    ],
    python_requires=">=3.7",
    install_requires=[
        "Flask>=3.0.0",
        "Flask-CORS>=4.0.0",
        "requests>=2.31.0",
        "pathlib2>=2.3.7",
        "colorama>=0.4.6",
    ],
    entry_points={
        "console_scripts": [
            "unqperp=server:main",
        ],
    },
    include_package_data=True,
    zip_safe=False,
    keywords="ai artificial-intelligence codebase flask api tunnel perplexity development unqofficial",
    project_urls={
        "Bug Reports": "https://github.com/UnQOfficial/UnQPerp/issues",
        "Source": "https://github.com/sandeepgaddam/UnQOfficial",
        "Documentation": "https://github.com/UnQOfficial/UnQPerp/main/README.md",
    },
)
