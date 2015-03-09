--反击装甲
function c24094672.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_BE_BATTLE_TARGET)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCondition(c24094672.condition)
	e1:SetOperation(c24094672.operation)
	c:RegisterEffect(e1)
end
function c24094672.condition(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	return d:IsFaceup() and a:IsControler(1-tp)
end
function c24094672.eqlimit(e,c)
	return c==e:GetLabelObject()
end
function c24094672.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ec=Duel.GetAttacker()
	local tc=Duel.GetAttackTarget()
	if ec:IsRelateToEffect(e) and ec:IsAttackable() and not ec:IsStatus(STATUS_ATTACK_CANCELED)
		and tc:IsLocation(LOCATION_MZONE) and tc:IsFaceup() then
		local atk=ec:GetTextAttack()
		if atk<0 then atk=0 end
		local lp=Duel.GetLP(tp)
		if lp<=1000 then
			Duel.SetLP(tp,0)
		else
			Duel.SetLP(tp,lp-1000)
		end
		Duel.Equip(tp,ec,tc)
		--Add Equip limit
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		e1:SetValue(c24094672.eqlimit)
		e1:SetLabelObject(tc)
		ec:RegisterEffect(e1)
		if atk>0 then
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_EQUIP)
			e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_CANNOT_DISABLE)
			e2:SetCode(EFFECT_UPDATE_ATTACK)
			e2:SetReset(RESET_EVENT+0x1fe0000)
			e2:SetValue(atk)
			e2:SetLabelObject(tc)
			ec:RegisterEffect(e2)
		end
	end
end