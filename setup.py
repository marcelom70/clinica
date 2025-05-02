from setuptools import setup, find_packages

with open("README.md", "r", encoding="utf-8") as fh:
    long_description = fh.read()

with open("requirements.txt", "r", encoding="utf-8") as f:
    requirements = f.read().splitlines()

setup(
    name="clinica",
    version="0.1.0",
    author="Marcelo Martins",
    author_email="marcelo.marcelom@gmail.com",
    description="Clinic management system with AI-assisted diagnostics",
    long_description=long_description,
    long_description_content_type="text/markdown",
    url="https://github.com/marcelom70/clinica",
    packages=find_packages(),
    classifiers=[
        "Programming Language :: Python :: 3",
        "Programming Language :: Python :: 3.10",
        "License :: OSI Approved :: MIT License",
        "Operating System :: OS Independent",
    ],
    python_requires=">=3.10",
    install_requires=requirements,
    entry_points={
        "console_scripts": [
            "clinica=run:main",
        ],
    },
) 