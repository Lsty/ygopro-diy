--六道剑「一念无量劫」
function c81700110.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_ZOMBIE),2,3,c81700110.ovfilter,aux.Stringid(81700110,0),5)
	c:EnableReviveLimit()
	--direct attack
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_DIRECT_ATTACK)
	e1:SetCondition(c81700110.dacon)
	c:RegisterEffect(e1)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(81700110,1))
	e2:SetCategory(CATEGORY_DAMAGE+CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_BATTLE_DAMAGE)
	e2:SetCountLimit(1)
	e2:SetCondition(c81700110.descon)
	e2:SetTarget(c81700110.destg)
	e2:SetOperation(c81700110.desop)
	c:RegisterEffect(e2)
end
function c81700110.ovfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x817) and c:GetCode()~=81700110 and c:IsType(TYPE_XYZ)
end
function c81700110.dacon(e)
	return e:GetHandler():GetOverlayCount()>0
end
function c81700110.descon(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp
end
function c81700110.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_EFFECT) end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(e:GetHandler():GetOverlayCount()*600)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,e:GetHandler():GetOverlayCount()*600)
end
function c81700110.filter(c,e,tp)
	return c:IsSetCard(0x817) and c:IsType(TYPE_MONSTER) and c:IsFaceup()
end
function c81700110.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	local dam=e:GetHandler():GetOverlayCount()*600
	if Duel.Damage(p,dam,REASON_EFFECT)~=0 and e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_EFFECT) then
		Duel.BreakEffect()
		e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_EFFECT)
		if Duel.IsExistingMatchingCard(c81700110.filter,tp,LOCATION_MZONE,0,1,nil) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
			local g=Duel.SelectMatchingCard(tp,c81700110.filter,tp,LOCATION_MZONE,0,1,1,nil)
			local tc=g:GetFirst()
			if not tc:IsImmuneToEffect(e) and tc:IsFaceup() then
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_UPDATE_ATTACK)
				e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
				e1:SetReset(RESET_EVENT+0x1fe0000)
				e1:SetValue(dam)
				tc:RegisterEffect(e1)
				Duel.HintSelection(g)
			end
		end
	end
end