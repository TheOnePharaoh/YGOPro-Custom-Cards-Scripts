--Requipped Reserve Armory
function c77777820.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,77777820)
	e1:SetTarget(c77777820.destg)
	e1:SetOperation(c77777820.desop)
	c:RegisterEffect(e1)
end

function c77777820.cfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_EQUIP) and c:IsType(TYPE_SPELL)
		and c:IsSetCard(0x408)and c:IsDestructable()
end
function c77777820.desfilter(c)
	return  c:IsDestructable()
end
function c77777820.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c77777820.cfilter,tp,LOCATION_ONFIELD,0,nil)
	local ct=g:GetCount()
	if chk==0 then return  Duel.IsExistingMatchingCard(c77777820.cfilter,tp,LOCATION_ONFIELD,0,1,nil)
		and Duel.IsPlayerCanDraw(tp,ct) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,ct)
end
function c77777820.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g1=Duel.GetMatchingGroup(c77777820.cfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	local ct=g1:GetCount()
	if Duel.Destroy(g1,REASON_EFFECT)~=0 then
		Duel.Draw(tp,ct,REASON_EFFECT)
	end
end

function c77777820.filter2(c)
	return c:IsSetCard(0x408) and c:IsType(TYPE_SPELL) and c:IsType(TYPE_EQUIP) and c:IsAbleToHand()
end