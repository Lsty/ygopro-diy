--夜夜 森闲绝冲:神机御雷
function c1314528.initial_effect(c)
	c:EnableReviveLimit()
	--negate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(1314528,0))
	e1:SetCategory(CATEGORY_DISABLE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(0x2)
	e1:SetCondition(c1314528.negcon)
	e1:SetCost(c1314528.negcost)
	e1:SetTarget(c1314528.negtg)
	e1:SetOperation(c1314528.negop)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(1314528,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCountLimit(1,1314528)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTarget(c1314528.sumtg)
	e2:SetOperation(c1314528.sumop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_REMOVED)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_TO_HAND)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1,13145281)
	e3:SetCondition(c1314528.condition)
	e3:SetTarget(c1314528.totg)
	e3:SetOperation(c1314528.toop)
	c:RegisterEffect(e3)

end
function c1314528.tfilter(c,tp)
	return c:IsLocation(0x4) and c:IsControler(tp) and c:IsFaceup() and c:IsSetCard(0x9fd)
end
function c1314528.negcon(e,tp,eg,ep,ev,re,r,rp)
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local g=Duel.GetChainInfo(ev,0x40)
	return g and g:IsExists(c1314528.tfilter,1,nil,tp) and Duel.IsChainDisablable(ev)
end
function c1314528.negcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),0x5,0x80)
end
function c1314528.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
end
function c1314528.negop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
end
function c1314528.filter1(c,e)
	return c:IsType(0x1) and c:IsSetCard(0x9fd) and not c:IsImmuneToEffect(e) and c:IsAbleToRemove()
end
function c1314528.filter2(c,e,tp,m,f,chkf)
	return c:IsType(0x40) and c:IsSetCard(0x9fd) and (not f or f(c)) 
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(m,nil,chkf)
end
function c1314528.sumtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local chkf=Duel.GetLocationCount(tp,0x4)>0 and PLAYER_NONE or tp
		local mg1=Duel.GetMatchingGroup(c1314528.filter1,tp,0x6,0,nil,e)
		local res=Duel.IsExistingMatchingCard(c1314528.filter2,tp,0x40,0,1,nil,e,tp,mg1,nil,chkf)
		return res
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,0x40)
end
function c1314528.sumop(e,tp,eg,ep,ev,re,r,rp)
	local chkf=Duel.GetLocationCount(tp,0x4)>0 and PLAYER_NONE or tp
	local mg1=Duel.GetMatchingGroup(c1314528.filter1,tp,0x6,0,nil,e)
	local sg1=Duel.GetMatchingGroup(c1314528.filter2,tp,0x40,0,nil,e,tp,mg1,nil,chkf)
	if sg1:GetCount()>0  then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tc=sg1:Select(tp,1,1,nil):GetFirst()
		if tc then
			local mat1=Duel.SelectFusionMaterial(tp,tc,mg1,nil,chkf)
			tc:SetMaterial(mat1)
			Duel.Remove(mat1,0x5,0x40)
			Duel.BreakEffect()
			Duel.SpecialSummon(tc,0,tp,tp,false,false,0x5) 
		end
	end
end
function c1314528.condition(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(r,REASON_EFFECT)~=0 and e:GetHandler():IsPreviousLocation(LOCATION_DECK)
end
function c1314528.tgfilter(c)
	return c:IsType(0x1) and c:IsSetCard(0x9fd) and not c:IsCode(1314528) and c:IsAbleToRemove()
end
function c1314528.totg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c1314528.tgfilter,tp,LOCATION_DECK,0,1,nil) end
	local g=Duel.SelectTarget(tp,c1314528.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end 
function c1314528.toop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
	end 
end