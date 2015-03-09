--Gosick·茱莉
function c12250012.initial_effect(c)
	--to grave
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetOperation(c12250012.regop)
	c:RegisterEffect(e2)
	--destroy & damage
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_REMOVE)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_O)
	e5:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e5:SetCode(EVENT_MSET)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1)
	e5:SetCondition(c12250012.con)
	e5:SetCost(c12250012.setcost)
	e5:SetTarget(c12250012.settg)
	e5:SetOperation(c12250012.setop)
	c:RegisterEffect(e5)
	local e6=e5:Clone()
	e6:SetCode(EVENT_SSET)
	c:RegisterEffect(e6)
	local e7=e5:Clone()
	e7:SetCode(EVENT_CHANGE_POS)
	c:RegisterEffect(e7)
	local e8=e7:Clone()
	e8:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e8)
end
function c12250012.regop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if bit.band(c:GetPreviousLocation(),LOCATION_ONFIELD)~=0 and c:IsReason(REASON_DESTROY) then
		local e1=Effect.CreateEffect(c)
		e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetCountLimit(1)
		e1:SetRange(LOCATION_GRAVE)
		e1:SetTarget(c12250012.target)
		e1:SetOperation(c12250012.operation)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
	end
end
function c12250012.sfilter(c,e,tp)
	return c:IsSetCard(0x4c9) and c:GetCode()~=12250012 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c12250012.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c12250012.sfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c12250012.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c12250012.sfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c12250012.con(e,tp,eg,ep,ev,re,r,rp)
	return rp~=tp
end
function c12250012.setcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetFlagEffect(12250012)==0 end
	e:GetHandler():RegisterFlagEffect(12250012,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
end
function c12250012.filter(c)
	return c:IsAbleToRemove()
end
function c12250012.setfilter(c,e)
	return c:IsFacedown() and c:IsLocation(LOCATION_ONFIELD)
end
function c12250012.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(c12250012.setfilter,1,nil,nil) and Duel.IsExistingMatchingCard(c12250012.filter,tp,0,LOCATION_GRAVE,1,nil) end
	Duel.SetTargetCard(eg)
end
function c12250012.setop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsExistingMatchingCard(c12250012.filter,tp,0,LOCATION_GRAVE,1,nil) then return end
	if not eg:IsExists(c12250012.setfilter,1,nil,nil) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CARDTYPE)
	local res=Duel.SelectOption(tp,70,71,72)
	local tc=eg:GetFirst()
	local mg=Group.CreateGroup()
	local m=0
	while tc do
		if tc:IsLocation(LOCATION_ONFIELD) and tc:IsRelateToEffect(e) and tc:IsFacedown() then
			mg:AddCard(tc)
			if (res==0 and tc:IsType(TYPE_MONSTER)) or (res==1 and tc:IsType(TYPE_SPELL)) or (res==2 and tc:IsType(TYPE_TRAP)) then m=m+1 end
		end
		tc=eg:GetNext()
	end
	Duel.ConfirmCards(tp,mg)
	if m~=0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g=Duel.SelectMatchingCard(tp,c12250012.filter,tp,0,LOCATION_GRAVE,1,2,nil)
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	end
end