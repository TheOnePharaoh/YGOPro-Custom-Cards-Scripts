--Mark of the Divine Aura
function c11478418.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c11478418.target)
	e1:SetOperation(c11478418.activate)
	c:RegisterEffect(e1)
	--draw
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(11478418,0))
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,11478418)
	e2:SetCost(c11478418.drcost)
	e2:SetTarget(c11478418.drtg)
	e2:SetOperation(c11478418.drop)
	c:RegisterEffect(e2)
end
function c11478418.filter(c,e,tp,m)
	if not c:IsSetCard(0xf2002) or bit.band(c:GetType(),0x81)~=0x81 or not c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true) then return false end
	if m:IsContains(c) then
		m:RemoveCard(c)
		result=m:CheckWithSumGreater(Card.GetRitualLevel,10,c)
		m:AddCard(c)
	else
		result=m:CheckWithSumGreater(Card.GetRitualLevel,10,c)
	end
	return result
end
function c11478418.mfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xf2000) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemove()
end
function c11478418.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local mg1=Duel.GetRitualMaterial(tp)
		local mg2=Duel.GetMatchingGroup(c11478418.mfilter,tp,LOCATION_GRAVE,0,nil)
		mg1:Merge(mg2)
		return Duel.IsExistingMatchingCard(c11478418.filter,tp,LOCATION_HAND,0,1,nil,e,tp,mg1)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c11478418.activate(e,tp,eg,ep,ev,re,r,rp)
	local mg1=Duel.GetRitualMaterial(tp)
	local mg2=Duel.GetMatchingGroup(c11478418.mfilter,tp,LOCATION_GRAVE,0,nil)
	mg1:Merge(mg2)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c11478418.filter,tp,LOCATION_HAND,0,1,1,nil,e,tp,mg1)
	local tc=g:GetFirst()
	if tc then
		mg1:RemoveCard(tc)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		local mat=mg1:SelectWithSumGreater(tp,Card.GetRitualLevel,10,tc)
		tc:SetMaterial(mat)
		Duel.ReleaseRitualMaterial(mat)
		Duel.BreakEffect()
		Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
		tc:CompleteProcedure()
	end
end
function c11478418.drcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToDeckAsCost() end
	Duel.SendtoDeck(e:GetHandler(),nil,2,REASON_COST)
end
function c11478418.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c11478418.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
