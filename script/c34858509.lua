--Crossing Heart
function c34858509.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetLabel(0)
	e1:SetCost(c34858509.cost)
	e1:SetTarget(c34858509.target)
	e1:SetOperation(c34858509.activate)
	c:RegisterEffect(e1)
end
function c34858509.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100)
	return true
end
function c34858509.filter1(c,e,tp)
	local lv=c:GetLevel()
	return lv>0 and c:IsFaceup() and c:IsType(TYPE_PENDULUM)
		and Duel.IsExistingMatchingCard(c34858509.filter2,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,lv,e,tp)
end
function c34858509.filter2(c,lv,e,tp)
	return (c:IsType(TYPE_PENDULUM) and c:GetLevel()==lv) or (c:IsType(TYPE_PENDULUM) and c:GetLevel()<=lv) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c34858509.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if e:GetLabel()~=100 then return false end
		e:SetLabel(0)
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
			and Duel.CheckReleaseGroup(tp,c34858509.filter1,1,nil,e,tp)
	end
	local rg=Duel.SelectReleaseGroup(tp,c34858509.filter1,1,1,nil,e,tp)
	e:SetLabel(rg:GetFirst():GetLevel())
	Duel.Release(rg,REASON_COST)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c34858509.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local lv=e:GetLabel()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c34858509.filter2,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,lv,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end

	