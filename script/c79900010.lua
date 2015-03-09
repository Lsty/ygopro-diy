--VOCALOID-骸音シーエ
function c79900010.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c79900010.spcon)
	c:RegisterEffect(e1)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE+CATEGORY_RECOVER)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCost(c79900010.cost)
	e2:SetTarget(c79900010.tg)
	e2:SetOperation(c79900010.op)
	c:RegisterEffect(e2)
end
function c79900010.spcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
		and Duel.GetLP(c:GetControler())<=2000
end
function c79900010.costfilter(c)
	return c:IsSetCard(0x799) and c:IsType(TYPE_MONSTER) and c:IsDiscardable() and c:IsAbleToGraveAsCost()
end
function c79900010.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c79900010.costfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,c79900010.costfilter,1,1,REASON_DISCARD+REASON_COST)
end
function c79900010.filter(c)
	return c:IsDestructable()
end
function c79900010.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and c79900010.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c79900010.filter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c79900010.filter,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c79900010.op(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		if Duel.Destroy(tc,REASON_EFFECT)>0 then
			Duel.BreakEffect()
			local atk=tc:GetBaseAttack()
			op=Duel.SelectOption(tp,aux.Stringid(79900010,0),aux.Stringid(79900010,1))
			if op==0 then
				Duel.Recover(1-tp,atk,REASON_EFFECT)
			else
				Duel.Damage(1-tp,atk/2,REASON_EFFECT)
			end
		end
	end
end