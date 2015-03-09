--常盘台的王牌 御坂美琴
function c16100010.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x161),5,2,c16100010.ovfilter,aux.Stringid(16100010,0),2,c16100010.xyzop)
	c:EnableReviveLimit()
	--actlimit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(0,1)
	e1:SetValue(c16100010.aclimit)
	e1:SetCondition(c16100010.actcon)
	c:RegisterEffect(e1)
	--draw
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCost(c16100010.cost)
	e2:SetTarget(c16100010.target)
	e2:SetOperation(c16100010.operation)
	c:RegisterEffect(e2)
end
function c16100010.ovfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x161) and c:GetCode()~=16100010 and c:IsType(TYPE_XYZ)
end
function c16100010.xyzop(e,tp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,16100010)==0 end
	Duel.RegisterFlagEffect(tp,16100010,RESET_EVENT+0xfe0000+RESET_PHASE+PHASE_END,0,1)
end
function c16100010.aclimit(e,re,tp)
	return not re:GetHandler():IsImmuneToEffect(e)
end
function c16100010.actcon(e)
	return Duel.GetAttacker()==e:GetHandler() or Duel.GetAttackTarget()==e:GetHandler()
end
function c16100010.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c16100010.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c16100010.operation(e,tp,eg,ep,ev,re,r,rp,chk)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end