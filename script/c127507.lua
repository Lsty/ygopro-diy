--时幻风神 黄金之王哈斯塔
function c127507.initial_effect(c)
	--pendulum summon
	aux.AddPendulumProcedure(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--disable
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_POSITION)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetRange(LOCATION_HAND)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,127507)
	e2:SetCondition(c127507.condition)
	e2:SetOperation(c127507.operation)
	c:RegisterEffect(e2)
end

function c127507.cfilter2(c)
	return c:IsFaceup() and c:IsSetCard(0x7fa) and c:IsType(TYPE_MONSTER)
end
function c127507.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c127507.cfilter2,tp,LOCATION_MZONE,0,1,nil) and tp~=Duel.GetTurnPlayer()
end
function c127507.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local tg=eg:GetFirst()
	if tg then
		Duel.ChangePosition(tg,POS_FACEDOWN_DEFENCE)
	end
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
end
