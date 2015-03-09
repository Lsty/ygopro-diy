--Æßê×Ö®Ä§Å®~Ë®·û¡¸ºþÔá¡¹~
function c15300080.initial_effect(c)
	--pendulum summon
	aux.AddPendulumProcedure(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--sum limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetTargetRange(1,0)
	e2:SetTarget(c15300080.splimit)
	c:RegisterEffect(e2)
	--Destroy
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetCountLimit(1,15300080)
	e3:SetRange(LOCATION_PZONE)
	e3:SetCondition(c15300080.condition)
	e3:SetTarget(c15300080.detg)
	e3:SetOperation(c15300080.deop)
	c:RegisterEffect(e3)
	--destroy
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_TOGRAVE+CATEGORY_TODECK)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_SUMMON_SUCCESS)
	e4:SetCountLimit(1,15300081)
	e4:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e4:SetTarget(c15300080.destg)
	e4:SetOperation(c15300080.desop)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e5)
	--special summon
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetCode(EFFECT_SPSUMMON_PROC)
	e6:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e6:SetRange(LOCATION_HAND)
	e6:SetCondition(c15300080.pspcon)
	e6:SetOperation(c15300080.pspop)
	c:RegisterEffect(e6)
	local e7=e6:Clone()
	e7:SetRange(LOCATION_EXTRA)
	c:RegisterEffect(e7)
end
function c15300080.splimit(e,c,tp,sumtp,sumpos)
	return not c:IsRace(RACE_SPELLCASTER)
end
function c15300080.filter(c)
	return c:IsFacedown() or not c:IsSetCard(0x153)
end
function c15300080.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetMatchingGroupCount(c15300080.filter,e:GetHandler():GetControler(),LOCATION_ONFIELD,0,nil)==0
end
function c15300080.defilter(c)
	return c:IsFaceup() and c:IsSetCard(0x153) and c:IsAbleToDeck()
end
function c15300080.detg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) 
		and Duel.IsExistingMatchingCard(c15300080.defilter,tp,LOCATION_ONFIELD,0,1,nil) end
	local g=Duel.GetMatchingGroup(c15300080.defilter,tp,LOCATION_ONFIELD,0,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c15300080.deop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c15300080.defilter,tp,LOCATION_ONFIELD,0,1,1,nil)
	local tc=g:GetFirst()
	if not tc:IsImmuneToEffect(e) and Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)>0 then
		Duel.ShuffleDeck(tc:GetControler())
		Duel.Draw(p,d,REASON_EFFECT)
	end
end
function c15300080.desfilter(c)
	return c:IsAbleToGrave() and c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c15300080.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return true end
	local g=Duel.SelectMatchingCard(c15300080.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,g:GetCount(),0,0)
end
function c15300080.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,LOCATION_ONFIELD,LOCATION_ONFIELD)
	Duel.SendtoGrave(g,REASON_EFFECT)
end
function c15300080.pspfilter(c,tp)
	return c:IsAbleToDeckAsCost() and c:IsSetCard(0x155)
end
function c15300080.pspcon(e,c)
	if c==nil then return true end 
	local tp=c:GetControler()
	if Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)==0 then
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
		and Duel.IsExistingMatchingCard(c15300080.pspfilter,tp,LOCATION_MZONE,0,1,e:GetHandler(),tp)
		and Duel.IsExistingMatchingCard(c15300080.pspfilter,tp,LOCATION_ONFIELD+LOCATION_HAND,0,2,e:GetHandler(),tp)
	else
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
		and Duel.IsExistingMatchingCard(c15300080.pspfilter,tp,LOCATION_ONFIELD+LOCATION_HAND,0,2,e:GetHandler(),tp)
	end
end
function c15300080.pspop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Group.CreateGroup()
	if Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)==0 then
		g=Duel.SelectMatchingCard(tp,c15300080.pspfilter,tp,LOCATION_MZONE,0,1,1,e:GetHandler(),tp)
		local g1=Duel.SelectMatchingCard(tp,c15300080.pspfilter,tp,LOCATION_ONFIELD+LOCATION_HAND,0,1,1,g:GetFirst())
		g:Merge(g1)
	else
		g=Duel.SelectMatchingCard(tp,c15300080.pspfilter,tp,LOCATION_ONFIELD+LOCATION_HAND,0,2,2,e:GetHandler(),tp)
	end
	local tc=g:GetFirst()
	while tc do
		if not tc:IsFaceup() then Duel.ConfirmCards(1-tp,tc) end
		tc=g:GetNext()
	end
	Duel.SendtoDeck(g,nil,2,REASON_COST)
end