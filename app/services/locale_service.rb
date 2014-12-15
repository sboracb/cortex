module LocaleService
  def all_locales
    expects_id!
    jargon_locales = jargon.localizations(jargon_id).query_locales
    if jargon_locales.is_error?
      throw Exception.new(jargon_locales)
    else
      cortex_locales = ::Localization.find_by_id(id).list_locales

      merge_locales(cortex_locales, jargon_locales.contents[:locales])
    end
  end

  def get_locale(locale_name)
    expects_id!
    cortex_locale = ::Localization.find_by_id(id).retrieve_locale(locale_name)
    jargon_locale = jargon.localizations(jargon_id).get_locale(locale_name).contents[:locale]

    merge_locale(cortex_locale, jargon_locale)
  end

  def delete_locale(locale_name)
    expects_id!
    jargon_locale = jargon.localizations(jargon_id).delete_locale(locale_name)
    if jargon_locale.is_error?
      throw Exception.new(jargon_locale)
    else
      cortex_locale = ::Localization.find_by_id(id).retrieve_locale(locale_name).delete

      cortex_locale
    end
  end

  def create_locale(body)
    expects_id!

    body[:json] = YAML.parse(body[:json]).to_json
    jargon_locale = jargon.localizations(jargon_id).save_locale(body)
    if jargon_locale.is_error?
      throw Exception.new(jargon_locale)
    else
      cortex_locale = ::Locale.new(body)
      cortex_locale.localization_id = id
      cortex_locale.user = @current_user
      cortex_locale.save!

      cortex_locale
    end
  end

  def update_locale(body)
    expects_id!

    body[:json] = YAML.parse(body[:json]).to_json
    jargon_locale = jargon.localizations(jargon_id).save_locale(body)
    if jargon_locale.is_error?
      throw Exception.new(jargon_locale)
    else
      cortex_locale = ::Locale.update!(body)
      cortex_locale.localization_id = id
      cortex_locale.save!

      cortex_locale
    end
  end
end
