CONFIG = YAML::load(File.open("./config/config.#{'test.' if test?}yml"))