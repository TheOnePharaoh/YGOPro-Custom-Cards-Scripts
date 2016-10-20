--Nibelung's Treasure
function c512000008.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c512000008.target)
	e1:SetOperation(c512000008.activate)
	c:RegisterEffect(e1)
end
function c512000008.thfilter(c,tp,eg,ep,ev,re,r,rp)
	local te=c:GetActivateEffect()
	if te then
		local condition=te:GetCondition()
		local cost=te:GetCost()
		local target=te:GetTarget()
		return c:IsType(TYPE_SPELL) and ((not condition or condition(te,1-tp,eg,ep,ev,re,r,rp)) and (not cost or cost(te,1-tp,eg,ep,ev,re,r,rp,0))
			and (not target or target(te,1-tp,eg,ep,ev,re,r,rp,0)) or c:IsSSetable())
	else
		return c:IsType(TYPE_SPELL) and c:IsSSetable()
	end
end
function c512000008.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c512000008.thfilter,tp,LOCATION_DECK,0,1,nil,tp,eg,ep,ev,re,r,rp) and Duel.IsPlayerCanDraw(tp,6) 
		and Duel.GetLocationCount(1-tp,LOCATION_SZONE)>0 end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(5)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,5)
end
function c512000008.activate(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	if Duel.GetLocationCount(1-tp,LOCATION_SZONE)<=0 then return end
	local sg=Duel.GetMatchingGroup(c512000008.thfilter,tp,LOCATION_DECK,0,nil,tp,eg,ep,ev,re,r,rp)
	Duel.ConfirmCards(1-tp,sg)
	local g=sg:Select(1-tp,1,1,nil)
	if g:GetCount()>0 then
		local tc=g:GetFirst()
        local tpe=tc:GetType()
		local te=tc:GetActivateEffect()
		local opt=0
		if tc:IsSSetable() then
			opt=opt+1
		end
        if te then
    	    local con=te:GetCondition()
			local co=te:GetCost()
			local tg=te:GetTarget()
			local op=te:GetOperation()
			local condition=(not con or con(te,1-tp,eg,ep,ev,re,r,rp)) and (not co or co(te,1-tp,eg,ep,ev,re,r,rp,0)) and (not tg or tg(te,1-tp,eg,ep,ev,re,r,rp,0))
			if (opt==1 and condition and Duel.SelectYesNo(1-tp,aux.Stringid(80604091,1))) or (opt==0 and condition) then
				opt=opt+2
				Duel.ClearTargetCard()
				e:SetCategory(te:GetCategory())
				e:SetProperty(te:GetProperty())
				if bit.band(tpe,TYPE_FIELD)~=0 then
					local of=Duel.GetFieldCard(1-tp,LOCATION_SZONE,5)
					if of and Duel.Destroy(of,REASON_RULE)==0 then Duel.SendtoGrave(tc,REASON_RULE) end
				end
				Duel.MoveToField(tc,tp,1-tp,LOCATION_SZONE,POS_FACEUP,true)
				Duel.Hint(HINT_CARD,0,tc:GetCode())
				tc:CreateEffectRelation(te)
				if bit.band(tpe,TYPE_EQUIP+TYPE_CONTINUOUS+TYPE_FIELD)==0 then
					tc:CancelToGrave(false)
				end
				if co then co(te,1-tp,eg,ep,ev,re,r,rp,1) end
				if tg then tg(te,1-tp,eg,ep,ev,re,r,rp,1) end
				local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
				if g then
					local etc=g:GetFirst()
					while etc do
						etc:CreateEffectRelation(te)
						etc=g:GetNext()
					end
				end
				Duel.BreakEffect()
				if op then op(te,1-tp,eg,ep,ev,re,r,rp) end
				tc:ReleaseEffectRelation(te)
				if etc then	
					etc=g:GetFirst()
					while etc do
						etc:ReleaseEffectRelation(te)
						etc=g:GetNext()
					end
				end
			end
		end
		if opt==0 then return Duel.SendtoGrave(tc,REASON_RULE) end
		if opt==1 then
			Duel.SSet(1-tp,tc)
			Duel.ConfirmCards(tp,tc)
		end
		Duel.ShuffleDeck(tp)
        Duel.Draw(p,d,REASON_EFFECT)
	end
end
