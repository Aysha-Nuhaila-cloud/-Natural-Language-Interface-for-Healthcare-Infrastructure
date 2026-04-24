from healthcare_bot import PROJECT_NAME, EXIT_KEYWORDS, COMMANDS, chatbot_reply


def run_cli():
    print("=" * 60)
    print(f"  {PROJECT_NAME}")
    print("  Natural Language Interface for Healthcare")
    print("=" * 60)
    print("\nHello! Type a healthcare question and press Enter.")
    print("Type 'help' to see all commands.")
    print("Type 'exit' or 'quit' to stop.\n")

    # show some sample commands at startup
    print("Sample commands you can try:")
    for cmd in COMMANDS[:8]:
        print("  -", cmd["prompt"])
    print("  ... and more! Type 'help' for full list.\n")

    while True:
        user_input = input("You: ").strip()

        # check if user wants to exit
        if user_input.lower() in EXIT_KEYWORDS:
            print("Bot: Goodbye! Stay healthy :)")
            break

        if user_input == "":
            print("Bot: Please type something!")
            continue

        result = chatbot_reply(user_input)
        print("Bot:", result["reply"])
        print()


if __name__ == "__main__":
    run_cli()
