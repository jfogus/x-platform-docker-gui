import platform

import mac.setup
import lin.setup
import win.setup


def main():
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
                    
    process_system(system)


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


def process_system(system):
    """ Calls the appropriate function based on the given system. """
    if system == "Darwin":
        print("Darwin was chosen")
        # mac.setup.setup()
        pass
    elif system == "Linux":
        # lin.setup.setup()
        pass
    elif system == "Windows":
        print("Windows was chosen")
        win.setup.setup()
        pass
    else:
        # Unknown system
        print("Error: Unable to identify your operating system. Exiting.")


if __name__ == "__main__":
    main()
