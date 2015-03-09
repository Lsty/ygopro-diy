--七曜之魔女~土符「慵懒三石塔上级」~
function c15300150.initial_effect(c)
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
	e2:SetTarget(c15300150.splimit)
	c:RegisterEffect(e2)
	--destroy
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_HANDES+CATEGORY_DRAW)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_PZONE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCountLimit(1,15300150)
	e3:SetCost(c15300150.decost)
	e3:SetTarget(c15300150.detg)
	e3:SetOperation(c15300150.deop)
	c:RegisterEffect(e3)
	--destroy
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DISABLE)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_SUMMON_SUCCESS)
	e4:SetCountLimit(1,15300151)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e4:SetTarget(c15300150.destg)
	e4:SetOperation(c15300150.desop)
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
	e6:SetCondition(c15300150.pspcon)
	e6:SetOperation(c15300150.pspop)
	c:RegisterEffect(e6)
	local e7=e6:Clone()
	e7:SetRange(LOCATION_EXTRA)
	c:RegisterEffect(e7)
end
function c15300150.splimit(e,c,tp,sumtp,sumpos)
	return not c:IsRace(RACE_SPELLCASTER)
end
function c15300150.decost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToDeckAsCost() end
	Duel.SendtoDeck(c,nil,2,REASON_COST)
end
function c15300150.defilter(c)
	return c:IsFaceup()
end
function c15300150.detg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local h=Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)
		return h>0
	end
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,1-tp,1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,1-tp,1)
end
function c15300150.deop(e,tp,eg,ep,ev,re,r,rp)
	local h=Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)
	local g=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
	Duel.SendtoGrave(g,REASON_EFFECT+REASON_DISCARD)
	Duel.Draw(1-tp,h,REASON_EFFECT)
end
function c15300150.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToDeck,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,Card.IsAbleToDeck,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,3,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,3,0,0)
end
function c15300150.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=g:Filter(Card.IsRelateToEffect,nil,e)
	Duel.SendtoDeck(sg,nil,2,REASON_EFFECT)
end
function c15300150.pspfilter(c,tp)
	return c:IsAbleToDeckAsCost() and c:IsSetCard(0x158)
end
function c15300150.pspcon(e,c)
	if c==nil then return true end 
	local tp=c:GetControler()
	if Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)==0 then
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
		and Duel.IsExistingMatchingCard(c15300150.pspfilter,tp,LOCATION_MZONE,0,1,e:GetHandler(),tp)
	else
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
		and Duel.IsExistingMatchingCard(c15300150.pspfilter,tp,LOCATION_ONFIELD+LOCATION_HAND,0,1,e:GetHandler(),tp)
	end
end
function c15300150.pspop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Group.CreateGroup()
	if Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)==0 then
		g=Duel.SelectMatchingCard(tp,c15300150.pspfilter,tp,LOCATION_MZONE,0,1,1,e:GetHandler(),tp)
	else
		g=Duel.SelectMatchingCard(tp,c15300150.pspfilter,tp,LOCATION_ONFIELD+LOCATION_HAND,0,1,1,e:GetHandler(),tp)
	end
	local tc=g:GetFirst()
	while tc do
		if not tc:IsFaceup() then Duel.ConfirmCards(1-tp,tc) end
		tc=g:GetNext()
	end
	Duel.SendtoDeck(g,nil,2,REASON_COST)
end