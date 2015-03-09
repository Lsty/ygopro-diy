---ÍÜá÷¡¸ÍÜÒÔ¿ÚÃù£¬·½ÖÂÉß»ö¡¹
function c329407.initial_effect(c)
	--Activate
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    c:RegisterEffect(e1)
    --special summon
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(329407,0))
    e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e2:SetCountLimit(1)
    e2:SetRange(LOCATION_SZONE)
    e2:SetTarget(c329407.target)
    e2:SetOperation(c329407.activate)
    c:RegisterEffect(e2)
	--extra summon
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetRange(LOCATION_SZONE)
	e4:SetTargetRange(LOCATION_HAND+LOCATION_MZONE,0)
	e4:SetCode(EFFECT_EXTRA_SUMMON_COUNT)
	e4:SetTarget(aux.TargetBoolFunction(Card.IsRace,RACE_REPTILE))
	c:RegisterEffect(e4)
	--
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetRange(LOCATION_SZONE)
	e5:SetTargetRange(LOCATION_MZONE,0)
	e5:SetCode(EFFECT_UPDATE_ATTACK)
	e5:SetTarget(aux.TargetBoolFunction(Card.IsRace,RACE_REPTILE))
	e5:SetValue(300)
	c:RegisterEffect(e5)
end
function c329407.filter1(c,e,tp)
    return c:IsFaceup() and c:IsSetCard(0x301)
        and Duel.IsExistingMatchingCard(c329407.filter2,tp,LOCATION_EXTRA,0,1,nil,c:GetAttribute(),e,tp)
end
function c329407.filter2(c,att,e,tp)
    return c:IsAttribute(att) and c:IsSetCard(0x301) and c:IsType(TYPE_XYZ) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function c329407.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c329407.filter1(chkc,e,tp) end
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
        and Duel.IsExistingTarget(c329407.filter1,tp,LOCATION_MZONE,0,1,nil,e,tp) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
    local g=Duel.SelectTarget(tp,c329407.filter1,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c329407.activate(e,tp,eg,ep,ev,re,r,rp)
    if not e:GetHandler():IsRelateToEffect(e) then return end
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<0 then return end
    local tc=Duel.GetFirstTarget()
    if tc:IsFacedown() or not tc:IsRelateToEffect(e) or tc:IsControler(1-tp) or tc:IsImmuneToEffect(e) then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,c329407.filter2,tp,LOCATION_EXTRA,0,1,1,nil,tc:GetAttribute(),e,tp)
    local sc=g:GetFirst()
    if sc then
        local mg=tc:GetOverlayGroup()
        if mg:GetCount()~=0 then
            Duel.Overlay(sc,mg)
        end
        Duel.Overlay(sc,Group.FromCards(tc))
        Duel.SpecialSummon(sc,0,tp,tp,true,false,POS_FACEUP)
        sc:CompleteProcedure()
    end
end
function c329407.tgvalue(e,re,rp)
    return rp~=e:GetHandlerPlayer()
end