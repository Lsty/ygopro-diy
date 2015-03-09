--小小的神明  泄矢诹访子
function c329405.initial_effect(c)
	--spsummon
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(329405,0))
    e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e2:SetCode(EVENT_SUMMON_SUCCESS)
    e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e2:SetCountLimit(1,3294051)
    e2:SetTarget(c329405.sptg)
    e2:SetOperation(c329405.spop)
    c:RegisterEffect(e2)
	--destroy
	local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(329405,1))
    e3:SetCategory(CATEGORY_DESTROY)
    e3:SetType(EFFECT_TYPE_IGNITION)
    e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,3294052)
    e3:SetCost(c329405.descost)
    e3:SetTarget(c329405.destg)
    e3:SetOperation(c329405.desop)
    c:RegisterEffect(e3)
end
function c329405.spfilter(c,e,tp)
	return c:IsFaceup() and c:IsSetCard(0x301) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c329405.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_REMOVED) and c329405.filter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c329405.spfilter,tp,LOCATION_REMOVED,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c329405.spfilter,tp,LOCATION_REMOVED,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c329405.spop(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) then
        Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
    end
end
function c329405.cofilter(c)
    return c:IsFaceup() and c:IsSetCard(0x301) and c:IsAbleToDeckAsCost()
end
function c329405.descost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c329405.cofilter,tp,LOCATION_REMOVED,LOCATION_REMOVED,2,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMS_TODECK)
    local g=Duel.SelectMatchingCard(tp,c329405.cofilter,tp,LOCATION_REMOVED,LOCATION_REMOVED,2,2,nil)
    Duel.SendtoDeck(g,nil,2,REASON_COST)
end
function c329405.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsOnField() and chkc:IsDestructable() end
    if chk==0 then return Duel.IsExistingTarget(Card.IsDestructable,tp,0,LOCATION_ONFIELD,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
    local g=Duel.SelectTarget(tp,Card.IsDestructable,tp,0,LOCATION_ONFIELD,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c329405.desop(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc and tc:IsRelateToEffect(e) then
        Duel.Destroy(tc,REASON_EFFECT)
    end
end
