--六里雾中 伊吹萃香
function c41700005.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetLabel(0)
	e1:SetCost(c41700005.cost)
	e1:SetTarget(c41700005.target)
	e1:SetOperation(c41700005.activate)
	c:RegisterEffect(e1)
	--battle indestructable
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e2:SetValue(1)
	c:RegisterEffect(e2)
end
function c41700005.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100)
	return true
end
function c41700005.filter1(c,e,tp,cg,minc)
	return c:IsSetCard(0x417) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and cg:CheckWithSumGreater(Card.GetLevel,c:GetLevel(),minc,99)
end
function c41700005.cgfilter(c)
	return c:GetLevel()>0 and c:IsRace(RACE_FIEND) and c:IsType(TYPE_NORMAL) and c:IsAbleToGraveAsCost()
end
function c41700005.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local cg=Duel.GetMatchingGroup(c41700005.cgfilter,tp,LOCATION_MZONE,0,nil)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local minc=-ft+1
	if minc<=0 then minc=1 end
	if chk==0 then
		if e:GetLabel()~=100 then return false end
		e:SetLabel(0)
		return Duel.IsExistingMatchingCard(c41700005.filter1,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp,cg,minc)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local rg=Duel.SelectMatchingCard(tp,c41700005.filter1,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp,cg,minc)
	e:SetLabel(rg:GetFirst():GetLevel())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local sg=cg:SelectWithSumGreater(tp,Card.GetLevel,e:GetLabel(),minc,99)
	Duel.SendtoGrave(sg,REASON_COST)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c41700005.filter2(c,e,tp,lv)
	return c:IsSetCard(0x417) and c:GetLevel()<=lv and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c41700005.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c41700005.filter2,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp,e:GetLabel())
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
