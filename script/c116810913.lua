--冰精姉
function c116810913.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,4,3,c116810913.ovfilter,aux.Stringid(116810913,0))
	c:EnableReviveLimit()
	--attack twice
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(116810913,1))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCountLimit(1)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCost(c116810913.atcost)
	e1:SetTarget(c116810913.attg)
	e1:SetOperation(c116810913.atop)
	c:RegisterEffect(e1)
	--atk
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetValue(c116810913.atkval)
	c:RegisterEffect(e2)
	--actlimit
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCode(EFFECT_CANNOT_ACTIVATE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(0,1)
	e3:SetValue(c116810913.aclimit)
	e3:SetCondition(c116810913.actcon)
	c:RegisterEffect(e3)
end
function c116810913.ovfilter(c)
	return c:IsFaceup() and c:IsRankBelow(3) and c:IsSetCard(0x3e7)
end
function c116810913.atcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c116810913.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x3e7) and c:GetEffectCount(EFFECT_EXTRA_ATTACK)==0
end
function c116810913.attg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c116810913.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c116810913.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c116810913.filter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c116810913.atop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_EXTRA_ATTACK)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(1)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+RESET_END)
		tc:RegisterEffect(e1)
	end
end
function c116810913.atkval(e,c)
	return c:GetOverlayCount()*200
end
function c116810913.aclimit(e,re,tp)
	return not re:GetHandler():IsImmuneToEffect(e)
end
function c116810913.actcon(e)
	return Duel.GetAttacker()==e:GetHandler() or Duel.GetAttackTarget()==e:GetHandler()
end
