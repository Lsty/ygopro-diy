--美遊
function c18799995.initial_effect(c)
	--pendulum summon
	aux.AddPendulumProcedure(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--special summon
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetCode(EFFECT_SPSUMMON_PROC)
	e6:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e6:SetRange(LOCATION_HAND)
	e6:SetCondition(c18799995.spcon)
	c:RegisterEffect(e6)
	local e7=e6:Clone()
	e7:SetRange(LOCATION_EXTRA)
	c:RegisterEffect(e7)
	--draw
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(92676637,0))
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_BE_MATERIAL)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCondition(c18799995.drcon)
	e1:SetTarget(c18799995.drtg)
	e1:SetOperation(c18799995.drop)
	c:RegisterEffect(e1)
end
function c18799995.filter(c)
	return c:IsFaceup() and (c:IsSetCard(0x984) or c:IsSetCard(0x985)) and c:GetLevel()==4 and c:IsRace(RACE_SPELLCASTER)
end
function c18799995.spcon(e,c)
	if c==nil then return true end 
	local tp=c:GetControler()
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)==4 
		and Duel.IsExistingMatchingCard(c18799995.filter,tp,LOCATION_MZONE,0,1,e:GetHandler(),tp)
end
function c18799995.drcon(e,tp,eg,ep,ev,re,r,rp)
	return r==REASON_SYNCHRO and (re:GetHandler():IsSetCard(0x984) or re:GetHandler():IsSetCard(0x985))
end
function c18799995.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c18799995.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end