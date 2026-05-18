# prints installed packages. 
# most reliable as it only uses standard python without additional package dependencies.

from importlib.metadata import distributions
import sys

def print_installed_packages():
    installed = sorted(
        [(dist.metadata['Name'], dist.version) for dist in distributions()],
        key=lambda x: x[0].lower()
    )
    
    print(f"{'Package':<30} {'Version'}")
    print("-" * 50)
    for name, version in installed:
        print(f"{name:<30} {version}")

if __name__ == "__main__":
    print_installed_packages()