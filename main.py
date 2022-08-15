#!/usr/bin/env python3
import platform
import argparse

import mac.setup
import lin.setup
import win.setup


def main(argList: "list(str)") -> None:
    supported_systems = ["Darwin", "Linux", "Windows"]
    system = None

    while not system:
        if system is None:
            system = platform.system()

        if system not in supported_systems:
            choice = display_os_menu(supported_systems)

            if choice == len(supported_systems) + 1:
                exit(1)

            system = supported_systems[choice - 1]
        else:
            choice = display_system_conf_menu(system)

            if choice == "n":
                system = ""
            elif choice == "quit":
                exit(1)
                    
    process_system(system, argList)


def display_system_conf_menu(system: str) -> str:
    """ Receives a system name and displays a confirmation menu. """
    choice = ""

    while not choice:
        print("Your system appears to be {}. Is this correct? [y/n/quit]".format(system))
        
        choice = input("Choice: ").lower()

        if choice not in ["y", "n", "quit"]:
            print("Error, incorrect input. Please try again.")
            choice = ""

    return choice


def display_os_menu(supported_systems: "list[str]") -> int:
    """ Receives a list of supported systems and displays a numeric selection menu. """
    choice = 0

    while choice <= 0 or choice > len(supported_systems) + 1:
        print("Unable to identify your system. Please select your OS from the choices below:")

        for i, system in enumerate(supported_systems):
            print("\t[{}] - {}".format(i + 1, system))
        print("\t[{}] - Exit".format(len(supported_systems) + 1))

        choice = input("Choice: ")
        choice = int(choice) if choice.isnumeric() else 0

    return choice


def process_system(system: str, args: "list(str)") -> None:
    """ Calls the appropriate function based on the given system. """
    if system == "Darwin":
        mac.setup.setup(args)
    elif system == "Linux":
        lin.setup.setup(args)
    elif system == "Windows":
        win.setup.setup(args)
    else:
        # Unknown system
        print("Error: Unable to identify your operating system. Exiting.")


def parse_args():
    parser = argparse.ArgumentParser(description="Parse run options.")
    parser.add_argument("-i", "--install", action="store_true", help="Install dependencies.")
    parser.add_argument("-r", "--run", action="store_true", help="Run the docker container.")
    parser.add_argument("-u", "--uninstall", action="store_true", help="Uninstall dependencies.")

    return [arg for arg, isset in vars(parser.parse_args()).items() if isset]


if __name__ == "__main__":
    main(parse_args())
