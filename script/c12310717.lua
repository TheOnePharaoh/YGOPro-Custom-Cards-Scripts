--Big Hat Logan
--lua script by SGJin
function c12310717.initial_effect(c)
	--Only 1 face up Big Hat Logan
	c:SetUniqueOnField(1,0,85087012)
	--ATK Up! (Crystal Soul Mass)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(85087012,0))
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCost(c12310717.cost)
	e1:SetOperation(c12310717.operation)
	c:RegisterEffect(e1)
	--Can't be used for Synchro
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetValue(1)
	c:RegisterEffect(e2)
end
function c12310717.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDiscardDeckAsCost(tp,1) end
	local ct=Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)
	if ct==1 then 
		Duel.DiscardDeck(tp,1,REASON_COST)
		e:SetLabel(1)
	else
		if ct>5 then ct=5 end
		local t={}
		local l=1
		while l<=ct do
			t[l]=l
			l=l+1
		end
		local ac=0
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(12310717,2))
		ac=Duel.AnnounceNumber(tp,table.unpack(t))
		Duel.DiscardDeck(tp,ac,REASON_COST)
		e:SetLabel(ac)
	end
end
function c12310717.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		local ct=e:GetLabel()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		e1:SetValue(ct*300)
		c:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_UPDATE_LEVEL)
		e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		e2:SetValue(ct)
		c:RegisterEffect(e2)
	end
end