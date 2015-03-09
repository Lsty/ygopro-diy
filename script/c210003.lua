--炎崩眼·燃
function c210003.initial_effect(c)
	--Special Summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,2100031)
	e1:SetCondition(c210003.spcon)
	e1:SetOperation(c210003.spop)
	c:RegisterEffect(e1)
	--Xyz Summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(210003,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_MZONE+LOCATION_HAND)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1,210003)
	e2:SetCost(c210003.xyzcost)
	e2:SetCondition(c210003.xyzcon)
	e2:SetTarget(c210003.xyztg)
	e2:SetOperation(c210003.xyzop)
	c:RegisterEffect(e2)
	--To Hand
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(210003,1))
	e3:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e3:SetCode(EVENT_TO_DECK)
	e3:SetCountLimit(1,2100033)
	e3:SetCondition(c210003.thcon)
	e3:SetTarget(c210003.thtg)
	e3:SetOperation(c210003.thop)
	c:RegisterEffect(e3)
end
function c210003.spfilter(c)
	return c:IsAbleToDeckAsCost() and c:IsRace(RACE_FIEND) 
end
function c210003.spcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>-1
		and Duel.IsExistingMatchingCard(c210003.spfilter,c:GetControler(),LOCATION_MZONE+LOCATION_HAND,0,1,e:GetHandler())
end
function c210003.spop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c210003.spfilter,tp,LOCATION_MZONE+LOCATION_HAND,0,1,1,e:GetHandler())
	Duel.SendtoDeck(g,nil,2,REASON_COST)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetCategory(CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(c210003.rettg)
	e1:SetOperation(c210003.retop)
	e:GetHandler():RegisterEffect(e1)
end
function c210003.rettg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToDeck() end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,e:GetHandler(),1,0,0)
end
function c210003.retop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	Duel.SendtoDeck(c,nil,2,REASON_EFFECT)  
end
function c210003.xyzcon(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return ph==PHASE_BATTLE
end
function c210003.xyzcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c210003.mfilter1(c)
	return c:IsFaceup() and c:IsRace(RACE_FIEND) and not c:IsType(TYPE_TOKEN)
end
function c210003.mfilter2(c)
	return c:IsRace(RACE_FIEND)
end
function c210003.xyzfilter(c,mg)
	return c:IsXyzSummonable(mg)
end
function c210003.xyztg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local g=Duel.GetMatchingGroup(c210003.mfilter1,tp,LOCATION_ONFIELD,0,nil)
		if Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)<Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE) then
		local eg=Duel.GetMatchingGroup(c210003.mfilter2,tp,LOCATION_DECK,0,nil,e)
		g:Merge(eg) end
		return Duel.IsExistingMatchingCard(c210003.xyzfilter,tp,LOCATION_EXTRA,0,1,nil,g)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c210003.xyzop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c210003.mfilter1,tp,LOCATION_MZONE,0,nil)
	if Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)<Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE) then
	local eg=Duel.GetMatchingGroup(c210003.mfilter2,tp,LOCATION_DECK,0,nil,e)
	g:Merge(eg) end
	local xyzg=Duel.GetMatchingGroup(c210003.xyzfilter,tp,LOCATION_EXTRA,0,nil,g)
	if xyzg:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local xyz=xyzg:Select(tp,1,1,nil):GetFirst()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
		local sg=g:FilterSelect(tp,xyz.xyz_filter,xyz.xyz_count,xyz.xyz_count,nil)
		Duel.XyzSummon(tp,xyz,sg)
	end
end
function c210003.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function c210003.thfilter(c)
	return c:IsRace(RACE_FIEND) and c:GetLevel()==6 and c:IsAbleToHand()
		   and not c:IsCode(210003)
end
function c210003.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c210003.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c210003.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c210003.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end