--魔王的转变
function c11111001.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c11111001.condition)
	e1:SetCost(c11111001.cost)
	e1:SetTarget(c11111001.target)
	e1:SetOperation(c11111001.activate)
	c:RegisterEffect(e1)
end
function c11111001.cfilter(c)
	return c:IsFaceup() and c:IsRace(RACE_FAIRY+RACE_SPELLCASTER)
end
function c11111001.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c11111001.cfilter,tp,LOCATION_MZONE,0,1,nil)		
end
function c11111001.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,11111001)==0 end
	Duel.RegisterFlagEffect(tp,11111001,RESET_PHASE+PHASE_END,EFFECT_FLAG_OATH,1)
end
function c11111001.filter(c)
	local code=c:GetCode()
	return code==11111006 or code==11111007 and c:IsSSetable()
end
function c11111001.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(c11111001.filter,tp,LOCATION_DECK,0,1,nil) end
end
function c11111001.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,c11111001.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SSet(tp,g:GetFirst())
		Duel.ConfirmCards(1-tp,g)
	end
end