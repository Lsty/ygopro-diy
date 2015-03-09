--VOCALOID-论杀
function c79900020.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,0x1e0)
	e1:SetCondition(c79900020.condition)
	e1:SetTarget(c79900020.target)
	e1:SetOperation(c79900020.activate)
	c:RegisterEffect(e1)
end
function c79900020.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x799)
end
function c79900020.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c79900020.cfilter,tp,LOCATION_MZONE,0,1,nil) and Duel.GetLP(tp)<Duel.GetLP(1-tp)
end
function c79900020.filter(c)
	return c:IsDestructable()
end
function c79900020.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD) and chkc:IsControler(1-tp) and c79900020.filter(chkc,c:GetAttack()) end
	if chk==0 then return Duel.IsExistingTarget(c79900020.filter,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g2=Duel.SelectTarget(tp,c79900020.filter,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,ds,1,0,0)
end
function c79900020.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		if Duel.Destroy(tc,REASON_EFFECT)>0 and tc:IsType(TYPE_MONSTER) and tc:GetBaseAttack()~=0 then
			local atk=tc:GetBaseAttack()
			if Duel.GetLP(tp)>2000 then
				Duel.Damage(tp,atk/2,REASON_EFFECT)
				Duel.Damage(1-tp,atk/2,REASON_EFFECT)
			else
				Duel.Damage(1-tp,atk/2,REASON_EFFECT)
			end
		end
	end
end
