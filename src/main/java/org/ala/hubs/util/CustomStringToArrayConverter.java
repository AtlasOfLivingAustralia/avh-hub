package org.ala.hubs.util;

import org.springframework.core.convert.converter.Converter;
import org.springframework.util.StringUtils;

public class CustomStringToArrayConverter implements Converter<String, String[]> {
    @Override
    public String[] convert(String source) {
        return StringUtils.delimitedListToStringArray(source, ";");
    }
}
