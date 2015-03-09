--神操鸟 永寂海之塞壬
function c18702302.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(Card.IsRace,RACE_WINDBEAST),1)
	c:EnableReviveLimit()
	--Remove
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(61127349,0))
	e5:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e5:SetCode(EVENT_LEAVE_FIELD)
	e5:SetCountLimit(1,18702302)
	e5:SetOperation(c18702302.rmop)
	c:RegisterEffect(e5)
	--destroy & damage
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e5:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_O)
	e5:SetCode(EVENT_CHAINING)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCondition(c18702302.con)
	e5:SetCost(c18702302.setcost)
	e5:SetTarget(c18702302.settg)
	e5:SetOperation(c18702302.setop)
	c:RegisterEffect(e5)
	--direct
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(31437713,0))
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetCountLimit(1,187023020)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTarget(c18702302.target)
	e4:SetOperation(c18702302.operation)
	c:RegisterEffect(e4)
end
function c18702302.rmop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,0,LOCATION_EXTRA)
	local ct=3
	if g:GetCount()<ct then return end
	Duel.ConfirmCards(tp,g)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local sg=g:Select(tp,3,3,nil)
	Duel.SendtoGrave(sg,REASON_EFFECT)
end
function c18702302.con(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return not c:IsStatus(STATUS_BATTLE_DESTROYED) and not c:IsStatus(STATUS_CHAINING) and re:IsActiveType(TYPE_MONSTER) and rp~=tp
end
function c18702302.setcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c18702302.setfilter(c,e)
	return c:IsSetCard(0x257) and c:IsAbleToGrave()
end
function c18702302.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c18702302.setfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c18702302.setop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c18702302.setfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
    Duel.SendtoGrave(g,REASON_EFFECT)
	end
	e:GetHandler():RegisterFlagEffect(18702302,RESET_EVENT+0x1fe0000+RESET_PHASE+RESET_END,0,0)
end
function c18702302.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c18702302.filter,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c18702302.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c18702302.filter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,257,tp,tp,false,false,POS_FACEUP)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c18702302.filter2,tp,LOCATION_ONFIELD,0,1,1,nil,nil)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end
function c18702302.filter(c,e,tp)
	return c:IsSetCard(0x257) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c18702302.filter2(c)
	return c:IsSetCard(0x257) and c:IsAbleToGrave()
end