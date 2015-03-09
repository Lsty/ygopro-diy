--吸血忍者 萨拉丝巴蒂
function c20130356.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetCondition(c20130356.spcon)
	e1:SetOperation(c20130356.spop1)
	c:RegisterEffect(e1)
	--attack cost
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_ATTACK_COST)
	e2:SetCost(c20130356.atcost)
	e2:SetOperation(c20130356.atop)
	c:RegisterEffect(e2)
	--token
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_DAMAGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(c20130356.damcon)
	e4:SetTarget(c20130356.damtg)
	e4:SetOperation(c20130356.damop)
	c:RegisterEffect(e4)
	--at limit
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e3:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
	e3:SetTarget(c20130356.atlimit)
	e3:SetValue(1)
	c:RegisterEffect(e3)
end
function c20130356.spcon(e,c,tp)
	if c==nil then return true end
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>-2
		and Duel.CheckReleaseGroup(c:GetControler(),Card.IsCode,2,nil,20130324)
end
function c20130356.spop1(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.SelectReleaseGroup(tp,Card.IsCode,2,2,nil,20130324)
	Duel.Release(g,REASON_COST)
end
function c20130356.atcost(e,c,tp)
	return Duel.CheckReleaseGroup(tp,Card.IsCode,1,nil,20130324)
end
function c20130356.atop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.SelectReleaseGroup(tp,Card.IsCode,1,1,nil,20130324)
	Duel.Release(g,REASON_COST)
end
function c20130356.damcon(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp and r==REASON_BATTLE and eg:GetFirst()==e:GetHandler()
end
function c20130356.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c20130356.damop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	if Duel.IsPlayerCanSpecialSummonMonster(tp,20130325,0,0x4011,0,0,2,RACE_FIEND,ATTRIBUTE_LIGHT) then
		local token=Duel.CreateToken(tp,20130325)
		Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UNRELEASABLE_SUM)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(c20130356.sumlimit)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		token:RegisterEffect(e1,true)
		Duel.SpecialSummonComplete()
	end
end
function c20130356.sumlimit(e,c)
	return not c:IsRace(RACE_FIEND)
end
function c20130356.atlimit(e,c)
	return c~=e:GetHandler()
end