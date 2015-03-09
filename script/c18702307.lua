--操鸟师 不死鸟
function c18702307.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCountLimit(1,18702307)
	e1:SetCode(EVENT_DESTROYED)
	e1:SetCondition(c18702307.condition)
	e1:SetTarget(c18702307.target)
	e1:SetOperation(c18702307.operation)
	c:RegisterEffect(e1)
    --destroy
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(45286019,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,187023070)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c18702307.descon)
	e1:SetTarget(c18702307.destg)
	e1:SetOperation(c18702307.desop)
	c:RegisterEffect(e1)
end
function c18702307.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsLocation(LOCATION_GRAVE)
end
function c18702307.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c18702307.thfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c18702307.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c18702307.thfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,257,tp,tp,false,false,POS_FACEUP)
	end
end
function c18702307.thfilter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,257,tp,false,false) and c:IsSetCard(0x257)
end
function c18702307.descon(e,tp,eg,ep,ev,re,r,rp)
	local st=e:GetHandler():GetSummonType()
	return st>=(SUMMON_TYPE_SPECIAL+250) and st<(SUMMON_TYPE_SPECIAL+260)
end
function c18702307.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c18702307.filter,tp,LOCATION_DECK,0,1,nil,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,0,tp,1)
end
function c18702307.desop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c18702307.filter,tp,LOCATION_DECK,0,1,1,nil,nil)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end
function c18702307.filter(c)
	return c:IsSetCard(0x257) and c:IsAbleToGrave()
end