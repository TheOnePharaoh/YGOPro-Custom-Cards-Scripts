--Sweet so Sweet - Song of Desperation
function c72839686.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c72839686.descon)
	e1:SetTarget(c72839686.destg)
	e1:SetOperation(c72839686.desop)
	c:RegisterEffect(e1)
end
function c72839686.confilter(c)
	return c:IsFaceup() and c:IsSetCard(0x0dac402) and c:IsType(TYPE_SYNCHRO)
end
function c72839686.descon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c72839686.confilter,tp,LOCATION_MZONE,0,2,nil)
end
function c72839686.filter1(c)
	return c:IsFaceup() and c:IsDestructable()
end
function c72839686.filter2(c)
	return c:IsFaceup() and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsDestructable()
end
function c72839686.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return 
		Duel.IsExistingMatchingCard(c72839686.filter1,tp,0,LOCATION_MZONE,1,nil) or
		Duel.IsExistingMatchingCard(c72839686.filter2,tp,0,LOCATION_ONFIELD,1,nil)
	end
	local t={}
	local p=1
	if Duel.IsExistingMatchingCard(c72839686.filter1,tp,0,LOCATION_MZONE,1,nil) then t[p]=aux.Stringid(72839686,0) p=p+1 end
	if Duel.IsExistingMatchingCard(c72839686.filter2,tp,0,LOCATION_ONFIELD,1,nil) then t[p]=aux.Stringid(72839686,1) p=p+1 end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(72839686,2))
	local sel=Duel.SelectOption(tp,table.unpack(t))+1
	local opt=t[sel]-aux.Stringid(72839686,0)
	local sg=nil
	if opt==0 then sg=Duel.GetMatchingGroup(c72839686.filter1,tp,0,LOCATION_MZONE,nil)
	elseif opt==1 then sg=Duel.GetMatchingGroup(c72839686.filter2,tp,0,LOCATION_ONFIELD,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,sg:GetCount(),0,0)
	e:SetLabel(opt)
end
function c72839686.desop(e,tp,eg,ep,ev,re,r,rp)
	local opt=e:GetLabel()
	local sg=nil
	if opt==0 then sg=Duel.GetMatchingGroup(c72839686.filter1,tp,0,LOCATION_MZONE,nil)
	elseif opt==1 then sg=Duel.GetMatchingGroup(c72839686.filter2,tp,0,LOCATION_ONFIELD,nil) 
	end
	Duel.Destroy(sg,REASON_EFFECT)
end
