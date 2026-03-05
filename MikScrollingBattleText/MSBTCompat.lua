-- MSBT Retail Compatibility Layer (Retail 12.x+)

-- Some legacy globals (e.g., GetSpellInfo / GetSpellCooldown) may be removed on modern Retail.
-- This file provides stable wrappers used throughout MSBT.

-- Metadata API
MSBT_GetAddOnMetadata = (C_AddOns and C_AddOns.GetAddOnMetadata) or _G.GetAddOnMetadata

-- Spell info wrapper
-- Returns: name, subText(nil), icon
function MSBT_GetSpellInfo(spellIdentifier)
    if C_Spell and C_Spell.GetSpellInfo then
        local info = C_Spell.GetSpellInfo(spellIdentifier)
        if info then
            return info.name, nil, info.iconID
        end
    end

    -- Legacy fallback (may not exist on modern Retail)
    if type(_G.GetSpellInfo) == "function" then
        return _G.GetSpellInfo(spellIdentifier)
    end

    -- Could not resolve.
    return nil, nil, nil
end

-- Cooldown wrapper
-- Returns: startTime, duration, isEnabled
function MSBT_GetSpellCooldown(spellIdentifier)
    if C_Spell and C_Spell.GetSpellCooldown then
        local cd = C_Spell.GetSpellCooldown(spellIdentifier)
        if cd then
            return cd.startTime, cd.duration, cd.isEnabled
        end
    end

    -- Legacy fallback (may not exist on modern Retail)
    if type(_G.GetSpellCooldown) == "function" then
        return _G.GetSpellCooldown(spellIdentifier)
    end

    return nil, nil, nil
end

-- Safe CVar setter
function MSBT_SetCVar(name, value)
    if C_CVar and C_CVar.SetCVar then
        C_CVar.SetCVar(name, value)
    elseif type(_G.SetCVar) == "function" then
        _G.SetCVar(name, value)
    end
end

-- Skill name compatibility
-- MSBT uses this for profession/skill triggers; Retail can vary by client/version.
function GetSkillName(skillIndex)
    if C_TradeSkillUI and C_TradeSkillUI.GetProfessionInfo then
        local prof = C_TradeSkillUI.GetProfessionInfo(skillIndex)
        if prof and prof.professionName then
            return prof.professionName
        end
    end

    if type(_G.GetSkillLineInfo) == "function" then
        local name = _G.GetSkillLineInfo(skillIndex)
        return name
    end

    return nil
end
