--七曜之魔女~土符「三石塔的震动」~
function c15300160.initial_effect(c)
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
	e2:SetTarget(c15300160.splimit)
	c:RegisterEffect(e2)
	--30459350 chk
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(30459350)
	e3:SetRange(LOCATION_PZONE)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetTargetRange(0,1)
	c:RegisterEffect(e3)
	--cannot remove
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_CANNOT_REMOVE)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetRange(LOCATION_PZONE)
	e4:SetTargetRange(0,1)
	c:RegisterEffect(e4)
	--cannot be target
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e5:SetProperty(EFFECT_FLAG_IGNORE_RANGE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetTargetRange(LOCATION_MZONE,0)
	e5:SetTarget(c15300160.target)
	e5:SetValue(c15300160.tgvalue)
	c:RegisterEffect(e5)
	--special summon
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetCode(EFFECT_SPSUMMON_PROC)
	e6:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e6:SetRange(LOCATION_HAND)
	e6:SetCondition(c15300160.pspcon)
	e6:SetOperation(c15300160.pspop)
	c:RegisterEffect(e6)
	local e7=e6:Clone()
	e7:SetRange(LOCATION_EXTRA)
	c:RegisterEffect(e7)
end
function c15300160.splimit(e,c,tp,sumtp,sumpos)
	return not c:IsSetCard(0x153)
end
function c15300160.target(e,c)
	return c:IsSetCard(0x153) and c:IsFaceup()
end
function c15300160.tgvalue(e,re,rp)
	return rp~=e:GetHandlerPlayer()
end
function c15300160.pspfilter(c,tp)
	return c:IsAbleToDeckAsCost() and c:IsSetCard(0x158)
end
function c15300160.pspcon(e,c)
	if c==nil then return true end 
	local tp=c:GetControler()
	if Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)==0 then
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
		and Duel.IsExistingMatchingCard(c15300160.pspfilter,tp,LOCATION_MZONE,0,1,e:GetHandler(),tp)
		and Duel.IsExistingMatchingCard(c15300160.pspfilter,tp,LOCATION_ONFIELD+LOCATION_HAND,0,2,e:GetHandler(),tp)
	else
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
		and Duel.IsExistingMatchingCard(c15300160.pspfilter,tp,LOCATION_ONFIELD+LOCATION_HAND,0,2,e:GetHandler(),tp)
	end
end
function c15300160.pspop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Group.CreateGroup()
	if Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)==0 then
		g=Duel.SelectMatchingCard(tp,c15300160.pspfilter,tp,LOCATION_MZONE,0,1,1,e:GetHandler(),tp)
		local g1=Duel.SelectMatchingCard(tp,c15300160.pspfilter,tp,LOCATION_ONFIELD+LOCATION_HAND,0,1,1,g:GetFirst())
		g:Merge(g1)
	else
		g=Duel.SelectMatchingCard(tp,c15300160.pspfilter,tp,LOCATION_ONFIELD+LOCATION_HAND,0,2,2,e:GetHandler(),tp)
	end
	local tc=g:GetFirst()
	while tc do
		if not tc:IsFaceup() then Duel.ConfirmCards(1-tp,tc) end
		tc=g:GetNext()
	end
	Duel.SendtoDeck(g,nil,2,REASON_COST)
end